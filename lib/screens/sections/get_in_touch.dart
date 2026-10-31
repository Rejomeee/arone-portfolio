import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:reactive_forms/reactive_forms.dart';
import '../../components/reactive_input_field.dart';
import '../../constant/data.dart';
import '../../constant/style.dart';
import '../../services/send_email.dart';
import '../../utils/open_link.dart';
import '../../widgets/section_header.dart';
import '../../widgets/portfolio_preview_scope.dart';

typedef EmailSender =
    Future<http.Response> Function(
      String name,
      String email,
      String message,
      String subject,
    );

class GetInTouchSection extends StatefulWidget {
  const GetInTouchSection({super.key, this.emailSender = sendEmail});
  final EmailSender emailSender;
  @override
  State<GetInTouchSection> createState() => _GetInTouchSectionState();
}

class _GetInTouchSectionState extends State<GetInTouchSection> {
  final contactForm = FormGroup({
    'name': FormControl<String>(value: '', validators: [Validators.required]),
    'email': FormControl<String>(
      value: '',
      validators: [Validators.required, Validators.email],
    ),
    'subject': FormControl<String>(value: ''),
    'message': FormControl<String>(
      value: '',
      validators: [Validators.required],
    ),
  });
  bool _isSubmitting = false;
  String? _error;
  bool _sent = false;
  @override
  void dispose() {
    contactForm.dispose();
    super.dispose();
  }

  String _value(String name) =>
      '${contactForm.control(name).value ?? ''}'.trim();
  Future<void> _submit() async {
    if (PortfolioPreviewScope.of(context)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Messages are disabled in draft preview.'),
        ),
      );
      return;
    }
    if (_isSubmitting) return;
    contactForm.markAllAsTouched();
    if (contactForm.invalid) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
      _sent = false;
    });
    try {
      final response = await widget.emailSender(
        _value('name'),
        _value('email'),
        _value('message'),
        _value('subject'),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        contactForm.reset();
        setState(() => _sent = true);
      } else {
        setState(
          () => _error =
              'Your message wasn’t sent. Your draft is still here—try again or email me directly.',
        );
      }
    } on TimeoutException {
      if (mounted) {
        setState(
          () => _error =
              'The request timed out. Your draft is still here—try again or email me directly.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Couldn’t connect. Your draft is still here—check your connection and try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) => ReactiveForm(
    formGroup: contactForm,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: Data.contactHeading),
        const SizedBox(height: 12),
        Text(Data.contactDescription, style: kTextBody),
        const SizedBox(height: 24),
        const _ContactDetails(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Divider(height: 1),
        ),
        const Text('Or leave a message', style: kTitle),
        const SizedBox(height: 6),
        const Text(
          'Name, email, and message are required.',
          style: kTextCaption,
        ),
        const SizedBox(height: 20),
        AutofillGroup(
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final name = ReactiveInputField(
                    formControlName: 'name',
                    title: 'Your name',
                    autofillHints: const [AutofillHints.name],
                    validationMessages: _messages,
                  );
                  final email = ReactiveInputField(
                    formControlName: 'email',
                    title: 'Your email',
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validationMessages: _messages,
                  );
                  if (constraints.maxWidth < 560) {
                    return Column(
                      children: [name, const SizedBox(height: 16), email],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: name),
                      const SizedBox(width: 16),
                      Expanded(child: email),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              const ReactiveInputField(
                formControlName: 'subject',
                title: 'Subject (optional)',
              ),
              const SizedBox(height: 16),
              ReactiveInputField(
                formControlName: 'message',
                title: 'Message',
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                validationMessages: _messages,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (_error != null || _sent)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Semantics(
              liveRegion: true,
              child: Text(
                _sent
                    ? 'Thanks for reaching out. Your message has been sent.'
                    : _error!,
                style: kTextSub.copyWith(
                  color: _sent ? kBadgeColorGreen : kColorRed,
                ),
              ),
            ),
          ),
        FilledButton.icon(
          onPressed: _isSubmitting ? null : _submit,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.arrow_forward_rounded, size: 18),
          label: Text(
            _isSubmitting
                ? 'Sending…'
                : _error != null
                ? 'Try again'
                : 'Send message',
          ),
        ),
      ],
    ),
  );
  Map<String, ValidationMessageFunction> get _messages => {
    ValidationMessage.required: (_) => 'This field is required',
    ValidationMessage.email: (_) => 'Enter a valid email address',
  };
}

class _ContactDetails extends StatelessWidget {
  const _ContactDetails();
  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: Data.email));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Email address copied')));
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Material(
            color: kCardTint,
            borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => openLink('mailto:${Data.email}'),
                    icon: const Icon(Icons.mail_outline_rounded, size: 20),
                    label: Text(Data.email),
                  ),
                ),
                IconButton(
                  tooltip: 'Copy email address',
                  onPressed: () => _copyEmail(context),
                  icon: const Icon(Icons.copy_outlined, size: 18),
                ),
              ],
            ),
          ),
          if (Data.linkedInUrl.isNotEmpty)
            TextButton.icon(
              onPressed: () => openLink(Data.linkedInUrl),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: const Text('LinkedIn'),
            ),
        ],
      ),
      Wrap(
        spacing: 20,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (Data.phoneNumber.isNotEmpty)
            TextButton.icon(
              onPressed: () => openLink('tel:${Data.phoneNumber}'),
              icon: const Icon(Icons.phone_outlined, size: 18),
              label: Text(Data.phoneNumber),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_outlined, size: 18, color: kTextColorGrey),
              SizedBox(width: 6),
              Flexible(child: Text(Data.location, style: kTextCaption)),
            ],
          ),
        ],
      ),
    ],
  );
}
