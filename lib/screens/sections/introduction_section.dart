import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import '../../constant/data.dart';
import '../../constant/style.dart';
import '../../utils/open_link.dart';

class IntroductionSection extends StatelessWidget {
  const IntroductionSection({super.key, this.constraints, this.onViewProjects});
  final BoxConstraints? constraints;
  final VoidCallback? onViewProjects;
  @override
  Widget build(BuildContext context) {
    final compact = (constraints?.maxWidth ?? 800) < 720;
    return Container(
      padding: EdgeInsets.all(compact ? 24 : 40),
      decoration: BoxDecoration(
        color: kColorWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  Data.heroEyebrow,
                  style: kTextCaption.copyWith(
                    color: kMainColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              if (!MediaQuery.disableAnimationsOf(context))
                const SizedBox(
                  width: 64,
                  height: 64,
                  child: _InteractiveBird(),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Semantics(
            header: true,
            child: Text(
              Data.heroHeadline,
              style: (compact ? kHeadline2 : kHeadline1).copyWith(
                color: kColorBlack,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            Data.heroDescription,
            style: TextStyle(fontSize: 17, height: 1.7, color: kTextColorGrey),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: onViewProjects,
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('View projects'),
              ),
              OutlinedButton.icon(
                onPressed: () => openLink(Data.cvUrl),
                icon: const Icon(Icons.download_outlined, size: 18),
                label: const Text('Download resume'),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Divider(height: 1),
          ),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              for (var i = 0; i < Data.specialties.length; i++)
                _Specialty(
                  icon: const [
                    Icons.flutter_dash,
                    Icons.phone_iphone_outlined,
                    Icons.integration_instructions_outlined,
                  ][i % 3],
                  label: Data.specialties[i],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Specialty extends StatelessWidget {
  const _Specialty({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: kMainColor),
      const SizedBox(width: 8),
      Flexible(child: Text(label, style: kTextCaption)),
    ],
  );
}

class _InteractiveBird extends StatefulWidget {
  const _InteractiveBird();
  @override
  State<_InteractiveBird> createState() => _InteractiveBirdState();
}

class _InteractiveBirdState extends State<_InteractiveBird> {
  Artboard? _artboard;
  StateMachineController? _controller;
  SMIInput<bool>? _dance;
  @override
  void initState() {
    super.initState();
    _loadBird();
  }

  Future<void> _loadBird() async {
    final bytes = await rootBundle.load('assets/animations/flutter_bird.riv');
    if (!mounted) return;
    final artboard = RiveFile.import(bytes).mainArtboard;
    final controller = StateMachineController.fromArtboard(artboard, 'birb');
    if (controller != null) {
      artboard.addController(controller);
      _controller = controller;
      _dance = controller.findInput<bool>('dance');
      _dance?.value = true;
    }
    setState(() => _artboard = artboard);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Tooltip(
    message: 'Tap the bird to toggle its dance',
    child: Semantics(
      label: 'Toggle the Flutter bird’s dance',
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _dance?.value = !(_dance?.value ?? false),
        child: _artboard == null
            ? const SizedBox.shrink()
            : Rive(artboard: _artboard!),
      ),
    ),
  );
}
