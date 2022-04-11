import 'package:blaze/components/default_text_button.dart';
import 'package:blaze/helpers/local/chache_helper.dart';
import 'package:blaze/models/on_barding.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../components/const.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController boardController = PageController();

  bool isLast = false;
  Icon icon = const Icon(Icons.arrow_forward_ios);

  void submit() {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value) {
      if (value) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', (Route<dynamic> route) => false);
      }
    });
  }

  List<BoardingModel> boarding = [
    BoardingModel(
        image: 'assets/images/onboard_1.png',
        title: 'Welcome to blaze',
        body: 'Share with the world your beauty'),
    BoardingModel(
        image: 'assets/images/onboard_2.png',
        body: 'Keeping up with friends is faster \n and easier than ever.',
        title: 'Hi There!'),
    BoardingModel(
        image: 'assets/images/onboard_3.png',
        body: 'Share updates and photos,\n engage with friends and Pages',
        title: 'Keep in touch'),
        
    BoardingModel(
        image: 'assets/images/onboard_4.png',
        body: 'join our community now',
        title: 'ARE YOU READY'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            defaultTextButton(
              function: submit,
              text: 'skip',
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  physics: ClampingScrollPhysics(),
                  controller: boardController,
                  onPageChanged: (int index) {
                    if (index == boarding.length - 1) {
                      setState(() {
                        isLast = true;
                        icon = const Icon(Icons.login);
                      });
                    } else {
                      setState(() {
                        isLast = false;
                        icon = const Icon(Icons.arrow_forward_ios);
                      });
                    }
                  },
                  itemBuilder: (context, index) =>
                      buildBoardingItem(boarding[index]),
                  itemCount: boarding.length,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                      controller: boardController,
                      count: boarding.length,
                      effect: const ExpandingDotsEffect(
                        dotWidth: 10.0,
                        radius: 16.0,
                        dotHeight: 12.0,
                        dotColor: Colors.grey,
                        strokeWidth: 10,
                        activeDotColor: defaultColor1,
                      )),
                  const Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if (isLast) {
                        submit();
                      } else {
                        boardController.nextPage(
                            duration: const Duration(microseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: icon,
                  )
                ],
              )
            ],
          ),
        ));
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        children: [
          Expanded(child: Image(image: AssetImage(model.image))),
          Text(
            model.title,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 30.0)
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            model.body,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      );
}
