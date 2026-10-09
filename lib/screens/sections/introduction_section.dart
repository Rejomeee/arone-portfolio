import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;

import '../../constant/data.dart';
import '../../constant/style.dart';
import '../../utils/open_link.dart';

class IntroductionSection extends StatefulWidget {
  const IntroductionSection({super.key, this.constraints});

  final BoxConstraints? constraints;

  @override
  State<IntroductionSection> createState() => _IntroductionSectionState();
}

class _IntroductionSectionState extends State<IntroductionSection> {
  Artboard? _artboard;
  SMIInput<bool>? _dance;

  @override
  void initState() {
    super.initState();
    _loadBird();
  }

  Future<void> _loadBird() async {
    final data = await rootBundle.load('assets/animations/flutter_bird.riv');
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;
    final controller = StateMachineController.fromArtboard(artboard, 'birb');
    if (controller != null) {
      artboard.addController(controller);
      _dance = controller.findInput<bool>('dance');
      _dance?.value = true;
    }
    if (!mounted) return;
    setState(() => _artboard = artboard);
  }

  void _toggleDance() {
    final dancing = _dance?.value ?? false;
    _dance?.value = !dancing;
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.constraints?.maxWidth ?? 800;
    final compact = width < 720;
    final firstName = Data.name.split(' ').first;

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(
        vertical: compact ? 28 : 48,
        horizontal: compact ? 20 : 40,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6D83F2), kMainColor, Color(0xFF3E56D4)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kMainColor.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "Hi, I'm $firstName",
                  style: (compact ? kHeadline2 : kHeadline1).copyWith(
                    color: kColorWhite,
                  ),
                ),
              ),
              SizedBox(
                width: 72,
                height: 72,
                child: _artboard == null
                    ? const SizedBox.shrink()
                    : Tooltip(
                        message: 'Tap the bird',
                        child: GestureDetector(
                          onTap: _toggleDance,
                          child: Rive(artboard: _artboard!),
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kColorWhite.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              Data.role,
              style: kTextSub.copyWith(color: kColorWhite),
            ),
          ),
          const SizedBox(height: 22),
          Text(Data.homeSentence, style: compact ? kTextSub2.copyWith(color: kColorWhite, fontSize: 20) : kQuote),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '— ${Data.homeAuthor}',
              style: kTextSub.copyWith(
                color: kColorWhite,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: () => openLink(Data.cvUrl),
            icon: const Icon(Icons.download_rounded),
            label: const Text('Resume'),
          ),
        ],
      ),
    );
  }
}
