import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../constant/data.dart';
import '../constant/style.dart';
import '../models/portfolio_content.dart';
import '../screens/portfolio_page.dart';
import '../services/content_repository.dart';
import '../services/github_publisher.dart';
import '../utils/open_link.dart';
import '../widgets/portfolio_preview_scope.dart';
import 'browser_storage.dart';

class CmsScreen extends StatefulWidget {
  const CmsScreen({
    super.key,
    this.exportJson = exportContentJson,
    this.loadPublished = loadPublishedPortfolio,
    this.publishContent = publishPortfolioToGitHub,
  });
  final void Function(String) exportJson;
  final Future<PortfolioContent> Function() loadPublished;
  final Future<GitHubPublishResult> Function(String, PortfolioContent)
  publishContent;
  @override
  State<CmsScreen> createState() => _CmsScreenState();
}

class _CmsScreenState extends State<CmsScreen> {
  final _password = TextEditingController();
  bool _unlocked = false;
  String? _githubToken;
  String? _publishedCommitUrl;
  bool _publishing = false;
  bool _loading = false;
  bool _saved = false;
  String? _error;
  String? _notice;
  late Map<String, dynamic> _draft;
  int _tab = 0;
  int _formVersion = 0;
  int _draftRevision = 0;
  bool _previewActive = false;
  Timer? _autosave;
  static const _tabs = [
    'Profile',
    'Home',
    'About',
    'Projects',
    'Experience',
    'Contact',
  ];

  @override
  void dispose() {
    _autosave?.cancel();
    _password.dispose();
    super.dispose();
  }

  void _unlock() {
    // Convenience gate only; the GitHub token grants publishing authority.
    if (_unlocked || _password.text != 'Password@1') return;
    _draft = Data.content.toJson();
    final local = readLocalDraft();
    String? notice;
    var restored = false;
    if (local != null) {
      try {
        _draft = PortfolioContent.fromJson(
          jsonDecode(local),
          validate: false,
        ).toJson();
        notice = 'Restored your browser draft.';
        restored = true;
      } catch (_) {
        notice =
            'The saved draft could not be restored. Current portfolio content is loaded.';
      }
    }
    _password.clear();
    setState(() {
      _unlocked = true;
      _error = null;
      _notice = notice;
      _saved = restored;
    });
    if (!restored) unawaited(_loadInitialPublished());
  }

  Future<void> _loadInitialPublished() async {
    final revision = _draftRevision;
    setState(() => _loading = true);
    try {
      final latest = await widget.loadPublished();
      if (!mounted || !_unlocked) return;
      if (!_previewActive) Data.apply(latest);
      if (revision == _draftRevision && !_previewActive) {
        setState(() {
          _draft = latest.toJson();
          _formVersion++;
          _notice = 'Loaded the latest content from GitHub.';
        });
      } else {
        setState(
          () => _notice =
              'Kept your edits. Load latest from GitHub if you want to replace this draft.',
        );
      }
    } catch (_) {
      if (mounted && _unlocked) {
        setState(
          () => _notice =
              'GitHub content is unavailable. Using the bundled copy; import your latest JSON if you have a newer version.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _changed() {
    _draftRevision++;
    _autosave?.cancel();
    if (_saved || _error != null || _notice != null) {
      setState(() {
        _saved = false;
        _error = null;
        _notice = null;
      });
    }
    _autosave = Timer(const Duration(milliseconds: 500), _saveDraft);
  }

  void _saveDraft() {
    final saved = writeLocalDraft(jsonEncode(_draft));
    if (!mounted) return;
    setState(() {
      _saved = saved;
      if (!saved) {
        _notice =
            'Browser storage is unavailable. Export your JSON to keep a copy.';
      }
    });
  }

  void _structure(VoidCallback action) {
    setState(() {
      action();
      _formVersion++;
    });
    _changed();
  }

  PortfolioContent? _validated() {
    try {
      return PortfolioContent.fromJson(_draft);
    } on FormatException catch (error) {
      setState(() => _error = error.message);
      return null;
    }
  }

  void _export() {
    FocusManager.instance.primaryFocus?.unfocus();
    final content = _validated();
    if (content == null) return;
    try {
      widget.exportJson(content.encode());
      _autosave?.cancel();
      _saveDraft();
      setState(
        () => _notice =
            'Exported a backup of portfolio.json. Click Publish to update the public portfolio.',
      );
    } catch (_) {
      setState(
        () => _error =
            'Couldn’t download the file. Use a web browser with downloads enabled.',
      );
    }
  }

  Future<void> _publish() async {
    if (_loading || _publishing) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final content = _validated();
    if (content == null) return;
    final revision = _draftRevision;
    setState(() {
      _publishing = true;
      _error = null;
      _notice = null;
    });
    try {
      final token =
          _githubToken ??
          await showDialog<String>(
            context: context,
            builder: (context) => const _GitHubTokenDialog(),
          );
      if (token == null || !mounted) return;
      setState(() => _githubToken = token);
      final result = await widget.publishContent(token, content);
      if (!mounted) return;
      Data.apply(content);
      _autosave?.cancel();
      _saveDraft();
      setState(() {
        _publishedCommitUrl = result.commitUrl;
        _notice = revision == _draftRevision
            ? 'Published to GitHub. Visitors will see the update after refreshing; GitHub caching may take a few minutes.'
            : 'Published the submitted version. Your newer edits are still an unpublished draft.';
      });
    } on GitHubPublishException catch (error) {
      if (error.forgetToken) _githubToken = null;
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Publishing could not be confirmed. Check GitHub before retrying. Your draft is still here.',
        );
      }
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  Future<void> _preview() async {
    final content = _validated();
    if (content == null) return;
    final published = Data.content;
    _previewActive = true;
    Data.apply(content);
    try {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Draft preview'),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(32),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Only you can see this draft. Sending messages is disabled.',
                    style: kTextCaption,
                  ),
                ),
              ),
            ),
            body: const PortfolioPreviewScope(
              child: PortfolioPage(syncFragment: false),
            ),
          ),
        ),
      );
    } finally {
      _previewActive = false;
      Data.apply(published);
    }
  }

  Future<bool> _confirmReplace(String message) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Replace this draft?'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Replace draft'),
            ),
          ],
        ),
      ) ??
      false;

  Future<void> _import() async {
    final value = await showDialog<String>(
      context: context,
      builder: (context) => const _JsonImportDialog(),
    );
    if (value == null || !mounted) return;
    try {
      final content = PortfolioContent.fromJson(jsonDecode(value));
      if (!await _confirmReplace(
        'Importing replaces the current browser draft. Export it first if you want to keep a copy.',
      )) {
        return;
      }
      if (!mounted) return;
      _autosave?.cancel();
      setState(() {
        _draftRevision++;
        _draft = content.toJson();
        _formVersion++;
        _error = null;
        _notice =
            'Imported successfully. This has not changed the public site.';
      });
      _saveDraft();
    } on FormatException catch (error) {
      if (mounted) {
        setState(() => _error = 'Invalid JSON. ${error.message}');
      }
    }
  }

  Future<void> _loadPublished() async {
    if (!await _confirmReplace(
      'This loads the latest JSON from GitHub and replaces your current draft. Export your draft first if you want to keep it.',
    )) {
      return;
    }
    if (!mounted) return;
    setState(() => _loading = true);
    final repository = ContentRepository();
    try {
      final content = await repository.loadPublished();
      if (!mounted) return;
      _autosave?.cancel();
      setState(() {
        _draftRevision++;
        _draft = content.toJson();
        _formVersion++;
        _error = null;
        _notice = 'Loaded the latest content from GitHub.';
      });
      _saveDraft();
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Couldn’t load GitHub content. Your draft is unchanged. The JSON may not have been uploaded yet.',
        );
      }
    } finally {
      repository.close();
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => _unlocked ? _editor() : _login();

  Widget _login() => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: TextField(
            controller: _password,
            autofocus: true,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            onChanged: (_) => _unlock(),
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _editor() => Scaffold(
    appBar: AppBar(
      title: const Text('Ekko · Portfolio editor', style: kTitle),
      actions: [
        TextButton.icon(
          onPressed: _publishing
              ? null
              : () {
                  _autosave?.cancel();
                  _saveDraft();
                  setState(() {
                    _unlocked = false;
                    _githubToken = null;
                    _publishedCommitUrl = null;
                    _error = null;
                  });
                },
          icon: const Icon(Icons.lock_outline_rounded, size: 18),
          label: const Text('Lock'),
        ),
        const SizedBox(width: 12),
      ],
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Make it yours.', style: kHeadline2),
              const SizedBox(height: 8),
              const Text(
                'Edit, preview, then publish directly to your portfolio. Drafts save in this browser until you publish.',
                style: kTextBody,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: _loading || _publishing ? null : _publish,
                    icon: _publishing && _githubToken != null
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.publish_outlined),
                    label: Text(
                      _publishing && _githubToken != null
                          ? 'Publishing…'
                          : 'Publish',
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _loading || _publishing ? null : _export,
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Export JSON'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _loading || _publishing ? null : _preview,
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Preview'),
                  ),
                  TextButton.icon(
                    onPressed: _loading || _publishing ? null : _import,
                    icon: const Icon(Icons.upload_file_outlined),
                    label: const Text('Import JSON'),
                  ),
                  if (_githubToken != null)
                    TextButton(
                      onPressed: _publishing
                          ? null
                          : () => setState(() => _githubToken = null),
                      child: const Text('Disconnect GitHub'),
                    ),
                  Text(
                    _saved
                        ? 'Draft saved in this browser'
                        : 'Editing browser draft',
                    style: kTextCaption,
                  ),
                ],
              ),
              if (_error != null || _notice != null)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _error != null ? const Color(0xFFFEF2F2) : kCardTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      _error ?? _notice!,
                      style: kTextSub.copyWith(
                        color: _error != null ? kColorRed : kMainColor,
                      ),
                    ),
                  ),
                ),
              if (_publishedCommitUrl != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => openLink(_publishedCommitUrl!),
                    icon: const Icon(Icons.open_in_new_rounded, size: 16),
                    label: const Text('View published commit'),
                  ),
                ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < _tabs.length; i++)
                    ChoiceChip(
                      label: Text(_tabs[i]),
                      selected: _tab == i,
                      onSelected: (_) => setState(() => _tab = i),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kColorWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kCardBorder),
                ),
                child: KeyedSubtree(
                  key: ValueKey('$_tab:$_formVersion'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _fields(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text(
                  'How to update the public portfolio',
                  style: kTextSub2,
                ),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      '1. Review your changes in Preview.\n2. Click Publish and enter your GitHub token for this session.\n3. Refresh the public portfolio. GitHub caching may take a few minutes.\n\nPublish updates only content/portfolio.json on master, without rebuilding Flutter. Export JSON remains available as a backup. Your token is forgotten on lock or refresh.',
                      style: kTextSub,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        TextButton.icon(
                          onPressed: () => openLink(
                            'https://github.com/Rejomeee/arone-portfolio/blob/master/content/portfolio.json',
                          ),
                          icon: const Icon(Icons.open_in_new_rounded, size: 18),
                          label: const Text('Open content file on GitHub'),
                        ),
                        TextButton(
                          onPressed: _loading || _publishing
                              ? null
                              : _loadPublished,
                          child: Text(
                            _loading ? 'Loading…' : 'Load latest from GitHub',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _field(
    Map<String, dynamic> map,
    String name,
    String label, {
    bool multiline = false,
    String? hint,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
      initialValue: map[name] as String,
      minLines: multiline ? 3 : 1,
      maxLines: multiline ? 8 : 1,
      decoration: InputDecoration(
        labelText: label,
        helperText: hint,
        helperMaxLines: 3,
        alignLabelWithHint: multiline,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        map[name] = value;
        _changed();
      },
    ),
  );
  Widget _lines(
    Map<String, dynamic> map,
    String name,
    String label, {
    bool paragraphs = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
      initialValue: (map[name] as List).join(paragraphs ? '\n\n' : '\n'),
      minLines: paragraphs ? 7 : 3,
      maxLines: 14,
      decoration: InputDecoration(
        labelText: label,
        helperText: paragraphs
            ? 'Leave a blank line between paragraphs.'
            : 'One item per line.',
        alignLabelWithHint: true,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        map[name] = value
            .split(paragraphs ? RegExp(r'\n\s*\n') : '\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList();
        _changed();
      },
    ),
  );
  Widget _heading(String value) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Text(value, style: kTitle),
  );
  List<Widget> _fields() {
    final profile = _draft['profile'] as Map<String, dynamic>;
    final hero = _draft['hero'] as Map<String, dynamic>;
    final about = _draft['about'] as Map<String, dynamic>;
    final projects = _draft['projects'] as Map<String, dynamic>;
    final contact = _draft['contact'] as Map<String, dynamic>;
    switch (_tab) {
      case 0:
        return [
          _heading('Profile & links'),
          for (final entry in {
            'name': 'Full name',
            'shortName': 'Short name (mobile header)',
            'role': 'Role',
            'location': 'Location',
            'email': 'Email address',
            'phoneNumber': 'Phone number (optional)',
            'birthday': 'Birthday (optional)',
            'webTitle': 'Browser title',
            'cvUrl': 'Resume download URL',
            'githubUrl': 'GitHub URL (optional)',
            'linkedInUrl': 'LinkedIn URL (optional)',
            'instagramUrl': 'Instagram URL (optional)',
            'facebookUrl': 'Facebook URL (optional)',
          }.entries)
            _field(profile, entry.key, entry.value),
          const Text(
            'The existing profile photo and Rive animations stay with the site.',
            style: kTextCaption,
          ),
        ];
      case 1:
        return [
          _heading('Your introduction'),
          _field(hero, 'eyebrow', 'Greeting'),
          _field(hero, 'headline', 'Headline', multiline: true),
          _field(hero, 'description', 'Introduction', multiline: true),
          _lines(hero, 'specialties', 'Specialties'),
        ];
      case 2:
        return [
          _heading('About you'),
          _lines(about, 'paragraphs', 'About paragraphs', paragraphs: true),
          _field(about, 'educationTitle', 'Education'),
          _field(about, 'educationDetail', 'School & dates'),
        ];
      case 3:
        return [
          _heading('Selected projects'),
          _field(projects, 'intro', 'Section introduction', multiline: true),
          for (var i = 0; i < (projects['items'] as List).length; i++)
            _project(projects['items'] as List, i),
          OutlinedButton.icon(
            onPressed: (projects['items'] as List).length >= 20
                ? null
                : () => _structure(
                    () => (projects['items'] as List).add({
                      'title': 'New project',
                      'overview': '',
                      'summary': '',
                      'coverLabel': 'SELECTED WORK',
                      'coverHeadline': '',
                      'features': <String>[],
                      'tools': <String>[],
                    }),
                  ),
            icon: const Icon(Icons.add),
            label: const Text('Add project'),
          ),
        ];
      case 4:
        return [
          _heading('Work experience'),
          for (var i = 0; i < (_draft['experiences'] as List).length; i++)
            _company(_draft['experiences'] as List, i),
          OutlinedButton.icon(
            onPressed: (_draft['experiences'] as List).length >= 20
                ? null
                : () => _structure(
                    () => (_draft['experiences'] as List).add({
                      'company': 'New company',
                      'roles': [_newRole()],
                    }),
                  ),
            icon: const Icon(Icons.add),
            label: const Text('Add company'),
          ),
        ];
      default:
        return [
          _heading('Contact & footer'),
          _field(contact, 'heading', 'Contact heading'),
          _field(
            contact,
            'description',
            'Contact introduction',
            multiline: true,
          ),
          _field(_draft, 'footer', 'Footer'),
          const Text(
            'Email, phone, and social links can be changed in Profile.',
            style: kTextCaption,
          ),
        ];
    }
  }

  Widget _controls(
    List items,
    int index,
    String kind, {
    bool canDelete = true,
  }) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      IconButton(
        tooltip: 'Move $kind up',
        onPressed: index == 0
            ? null
            : () => _structure(() {
                final item = items.removeAt(index);
                items.insert(index - 1, item);
              }),
        icon: const Icon(Icons.arrow_upward_rounded, size: 20),
      ),
      IconButton(
        tooltip: 'Move $kind down',
        onPressed: index == items.length - 1
            ? null
            : () => _structure(() {
                final item = items.removeAt(index);
                items.insert(index + 1, item);
              }),
        icon: const Icon(Icons.arrow_downward_rounded, size: 20),
      ),
      IconButton(
        tooltip: 'Remove $kind',
        onPressed: !canDelete
            ? null
            : () => _structure(() => items.removeAt(index)),
        icon: const Icon(Icons.delete_outline_rounded, size: 20),
      ),
    ],
  );
  Widget _project(List items, int index) {
    final item = items[index] as Map<String, dynamic>;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        key: ValueKey('project-$index-$_formVersion'),
        initiallyExpanded: index == 0,
        tilePadding: EdgeInsets.zero,
        title: Text(
          item['title'].toString().isEmpty ? 'Untitled project' : item['title'],
          style: kTextSub2,
        ),
        children: [
          _controls(items, index, 'project'),
          _field(item, 'title', 'Project title'),
          _field(item, 'overview', 'What it does', multiline: true),
          _field(item, 'summary', 'Your contribution', multiline: true),
          _field(item, 'coverLabel', 'Cover label'),
          _field(item, 'coverHeadline', 'Cover headline'),
          _lines(item, 'features', 'Features'),
          _lines(item, 'tools', 'Technologies'),
        ],
      ),
    );
  }

  Map<String, dynamic> _newRole() => {
    'title': 'New role',
    'period': '',
    'description': '',
    'tools': <String>[],
  };
  Widget _company(List companies, int index) {
    final company = companies[index] as Map<String, dynamic>;
    final roles = company['roles'] as List;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ExpansionTile(
        key: ValueKey('company-$index-$_formVersion'),
        initiallyExpanded: index == 0,
        tilePadding: EdgeInsets.zero,
        title: Text(
          company['company'].toString().isEmpty
              ? 'Untitled company'
              : company['company'],
          style: kTextSub2,
        ),
        children: [
          _controls(companies, index, 'company'),
          _field(company, 'company', 'Company name'),
          for (var i = 0; i < roles.length; i++) ...[
            _controls(roles, i, 'role', canDelete: roles.length > 1),
            _field(roles[i], 'title', 'Role title'),
            _field(roles[i], 'period', 'Dates'),
            _field(
              roles[i],
              'description',
              'What you worked on',
              multiline: true,
            ),
            _lines(roles[i], 'tools', 'Tools'),
            const Divider(),
          ],
          OutlinedButton.icon(
            onPressed: roles.length >= 20
                ? null
                : () => _structure(() => roles.add(_newRole())),
            icon: const Icon(Icons.add),
            label: const Text('Add role'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _JsonImportDialog extends StatefulWidget {
  const _JsonImportDialog();
  @override
  State<_JsonImportDialog> createState() => _JsonImportDialogState();
}

class _JsonImportDialogState extends State<_JsonImportDialog> {
  final _input = TextEditingController();
  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Import portfolio JSON'),
    content: SizedBox(
      width: 640,
      child: TextField(
        controller: _input,
        minLines: 8,
        maxLines: 16,
        decoration: const InputDecoration(
          labelText: 'Paste the contents of portfolio.json',
          alignLabelWithHint: true,
          border: OutlineInputBorder(),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, _input.text),
        child: const Text('Import'),
      ),
    ],
  );
}

class _GitHubTokenDialog extends StatefulWidget {
  const _GitHubTokenDialog();
  @override
  State<_GitHubTokenDialog> createState() => _GitHubTokenDialogState();
}

class _GitHubTokenDialogState extends State<_GitHubTokenDialog> {
  final _token = TextEditingController();
  @override
  void dispose() {
    _token.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Publish to GitHub'),
    content: SizedBox(
      width: 440,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rejomeee/arone-portfolio · master', style: kTextSub2),
          const SizedBox(height: 8),
          const Text(
            'Updates content/portfolio.json. Your token stays in memory for this session and is cleared when you lock or refresh.',
            style: kTextSub,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _token,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'GitHub token',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Use a fine-grained token for this repository with Contents: Read and write.',
            style: kTextCaption,
          ),
          TextButton(
            onPressed: () => openLink(
              'https://github.com/settings/personal-access-tokens/new',
            ),
            child: const Text('Create a GitHub token'),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: _token.text.trim().isEmpty
            ? null
            : () => Navigator.pop(context, _token.text.trim()),
        child: const Text('Publish'),
      ),
    ],
  );
}
