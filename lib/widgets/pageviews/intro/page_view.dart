import 'package:flutter/material.dart';
import 'package:go_class_parent/pages/pages.dart';
import 'package:go_class_parent/values/Colors.dart';

import '../dots_indicator.dart';

class IntroPageView extends StatefulWidget {
  @override
  _IntroPageViewState createState() => _IntroPageViewState();
}

class _IntroPageViewState extends State<IntroPageView> {
  final _controller = PageController(
    initialPage: 0,
  );

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = Colors.black.withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView(
          controller: _controller,
          children: [page1, page2],
        ),
        Positioned(
          bottom: 110.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: DotsIndicator(
                controller: _controller,
                itemCount: 2,
                onPageSelected: (int page) {
                  _controller.animateToPage(
                    page,
                    duration: _kDuration,
                    curve: _kCurve,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  get page1 => IntroPageTemplate(
        title1: 'Inscription',
        subtitle1: ' Créez votre compte',
        title2: 'Etape 1',
        description:
            'Au début, vous devez saisir votre code personnel fourni par l\'administration, puis créer votre compte.',
        asset: "assets/page_two.jpg",
      );

  get page2 => IntroPageTemplate(
        title1: 'Connexion',
        subtitle1: 'Acceder a votre espace',
        title2: 'Etape 2',
        description:
            'Si vous avez déja un compte,\n accéder a votre espace et profitez de nos fonctionnalités.',
        asset: "assets/page_one.jpg",
        showButton: true,
      );

  get page3 => IntroPageTemplate(
        title1: 'Allez-y',
        subtitle1: "Acceder a l'école",
        title2: 'Etape 3',
        description:
            'Une fois dans l\'application, vous receverez vos messages, notifications et fichier en temps réel.',
        showButton: true,
        asset: "assets/page_three.jpg",
      );
}

class IntroPageTemplate extends StatelessWidget {
  final String title1;
  final String subtitle1;
  final String title2;
  final String description;
  final String asset;
  final bool showButton;

  IntroPageTemplate(
      {this.title1,
      this.subtitle1,
      this.title2,
      this.description,
      this.showButton = false,
      this.asset});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (showButton) {
      Future.delayed(
        Duration(seconds: 3),
        () {
          Navigator.popAndPushNamed(context, InitialPage.routeName);
        },
      );
    }

    return Column(
      children: <Widget>[
        Container(
          height: height * 20 / 100,
          width: width,
          color: MAIN_COLOR_LIGHT,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title1,
                style: TextStyle(color: Colors.white, fontSize: 35),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  subtitle1,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: height * 60 / 100,
          width: double.infinity,
          color: WHITE,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image(
                  image: AssetImage(asset),
                  height: 300.0,
                ),
              ),
              Center(
                child: Text(
                  title2,
                  style: TextStyle(color: MAIN_COLOR_DARK, fontSize: 35),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: height * 20 / 100,
          width: width,
          color: WHITE,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                description,
                style: TextStyle(
                  color: MAIN_COLOR_DARK,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
