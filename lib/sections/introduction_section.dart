import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/constant/style.dart';
import 'package:flutter_my_portfolio/cubit/flutter_bird/flutter_bird_cubit.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'dart:js' as js;

class IntroductionSection extends StatefulWidget {
  const IntroductionSection({Key? key}) : super(key: key);

  @override
  State<IntroductionSection> createState() => _IntroductionSectionState();
}

class _IntroductionSectionState extends State<IntroductionSection> {
  /* Animation Start */
  SMIInput<bool>? flutterBirdIsClicked;

  loadAnimations() async {
    Artboard? flutterBirdArtboard;

    await rootBundle.load('assets/animations/flutter_bird.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;

        final controller =
            StateMachineController.fromArtboard(artboard, 'birb');
        if (controller != null) {
          artboard.addController(controller);
          flutterBirdIsClicked = controller.findInput('dance');
          flutterBirdIsClicked?.value = true;
        }
        flutterBirdArtboard = artboard;
      },
    );

    context.read<FlutterBirdCubit>().animateFlutterBird(flutterBirdArtboard);
  }

  @override
  void initState() {
    super.initState();
    loadAnimations();
  }

  /* Animation End */
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(
        vertical: 80,
        horizontal: 70,
      ),
      decoration: const BoxDecoration(
        color: Color(0xff5A72EA),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Hi! I'm Arone ",
                style: kHeadline1.copyWith(
                  color: kColorBlack,
                ),
              ),
              BlocBuilder<FlutterBirdCubit, FlutterBirdState>(
                builder: (context, flutterBirdState) {
                  return SizedBox(
                    width: 60,
                    height: 75,
                    // width: MediaQuery.of(context).size.width,
                    child: flutterBirdState is FlutterBirdMove
                        ? GestureDetector(
                            onTap: () {
                              flutterBirdIsClicked?.value =
                                  flutterBirdIsClicked?.value == false
                                      ? true
                                      : false;
                            },
                            child: Rive(
                                artboard:
                                    flutterBirdState.flutterBirdArtboard!),
                          )
                        : const SizedBox(),
                  );
                },
              ),
            ],
          ),
          Text(
            '“One of my most productive days was throwing away 1000 lines of code.”',
            style: kHeadline1.copyWith(
              color: kColorWhite,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '- Ken Thompson -',
              style: kTextBody3.copyWith(
                  color: kColorWhite, fontStyle: FontStyle.italic),
              textAlign: TextAlign.end,
            ),
          ),
          Wrap(
            spacing: 10,
            children: [
              ElevatedButton.icon(
                style: raisedButtonStyle,
                icon: const Icon(Icons.download),
                onPressed: _downloadCV,
                label: const Text('Download'),
              ),
              // OutlinedButton.icon(
              //   style: outlineButtonStyle,
              //   icon: const Icon(Icons.email),
              //   onPressed: () {},
              //   label: const Text('Hire me'),
              // )
            ],
          )
        ],
      ),
    );
  }

  void _downloadCV() {
    js.context.callMethod('open', [Data.CV_URL]);
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: kColorWhite,
    primary: kButtonColor,
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );

  final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
    primary: kColorWhite,
    side: const BorderSide(color: kColorWhite),
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );
}
