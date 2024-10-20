import 'package:alo_do_me_to/src/core/components/my_circular_background.dart';
import 'package:alo_do_me_to/src/core/components/my_circular_image_background.dart';
import 'package:alo_do_me_to/src/core/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          IntroductionScreen(
            key: introKey,
            globalBackgroundColor: Colors.white,
            skipStyle: ButtonStyle(
                textStyle:
                    WidgetStateProperty.all(const TextStyle(fontSize: 17)),
                foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary)),
            allowImplicitScrolling: true,
            autoScrollDuration: 300000,
            infiniteAutoScroll: true,
            pages: [
              PageViewModel(
                title: "",
                bodyWidget: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MyCircularImageBackground(
                        imagePath: const AssetImage('assets/images/audio.png'),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      // const SizedBox(height: 40),
                      SizedBox(
                        height: 150,
                        width: 130,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: 50,
                              child: MyCircularBackground(
                                color: Theme.of(context).colorScheme.secondary,
                                size: 76.0,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              child: MyCircularBackground(
                                size: 38.0,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      Text(
                          'Obtenez des réponses vocales Yoruba ou Fon  à vos préoccupations émises en  langue voulue',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff001B44)))
                    ],
                  ),
                ),
              ),
              PageViewModel(
                title: "",
                bodyWidget: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MyCircularImageBackground(
                        imagePath:
                            const AssetImage('assets/images/transcript.png'),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      // const SizedBox(height: 40),
                      SizedBox(
                        height: 150,
                        width: 130,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: 50,
                              child: MyCircularBackground(
                                color: Theme.of(context).colorScheme.secondary,
                                size: 76.0,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              child: MyCircularBackground(
                                size: 38.0,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      Text(
                          'Obtenez la transcription vocale en Fon ou Yoruba de vos documents écrits en  langues étrangères',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff001B44)))
                    ],
                  ),
                ),
              ),
            ],
            showSkipButton: false,
            skipOrBackFlex: 0,
            nextFlex: 0,
            // onChange: (val) {},
            skip: Text('Passer',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary)),
            next: Stack(
              alignment: Alignment.center,
              children: [
                MyCircularBackground(
                  color: Theme.of(context).colorScheme.primary,
                  size: 34,
                ),
                const Positioned(
                    child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ))
              ],
            ),
            done: Text('Terminer',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary)),
            onDone: () => _onIntroEnd(context),
            nextStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 248, 64, 64))),
            dotsDecorator: DotsDecorator(
              color: Colors.grey.shade300,
              size: const Size.square(10),
              activeColor: Theme.of(context).colorScheme.primary,
              activeSize: const Size.square(17),
            ),
            
          ),
          Positioned(
              left: -28,
              bottom: -1,
              child: MyCircularBackground(
                color: Theme.of(context).colorScheme.primary,
                size: 100,
              )),
          const Positioned(
              child: Divider(
            color: Colors.grey,
            height: 30,
            indent: 100,
            endIndent: 170,
          ))
        ],
      ),
    );
  }
}
