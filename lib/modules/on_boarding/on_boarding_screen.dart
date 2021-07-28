import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zenon/modules/login/login_screen.dart';
import 'package:zenon/modules/sign_up/sign_up_screen.dart';
import 'package:zenon/shared/components/components.dart';
import 'package:zenon/shared/network/local/cacheHelper.dart';
import 'package:zenon/shared/styles/colors.dart';
class BorardingModel {
  final String title;
  final String image;
  final String body;

  BorardingModel({
    @required this.title,
    @required this.image,
    @required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  //كل اللهاتحتاج تضيفه او تعدله هنا
  List<BorardingModel> boardingData = [
    BorardingModel(
      title: 'Zenon Store',
      image: 'assets/images/onboard5.png',
      body: 'Serving You As You Wish',
    )
    ,
    BorardingModel(
      title: 'Make orders online',
      image: 'assets/images/onboard1.png',
      body: 'Anywhere Any Time',
    ) ,
     BorardingModel(
      title: 'Smart shopping with us',
      image: 'assets/images/onboard3.png',
      body: 'Without crowding, Without delay, and the Fastest payment method',
    ),
  ];

  PageController boardController = PageController(initialPage: 0);
  bool isLast = false ;
  bool dipose = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child:defaultTextButton(onpressed: (){
                 CacheHelper.saveData(
                   key: 'onBoarding', 
                   value: true).then((value) {
                     if(value)
                     {
                       Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.fade, 
                      child: LoginScreen()));
                     }
                   }) ;
                                
              },
             text: 'Skip',
             textStyle:  TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
             ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount:boardingData.length,
               // pageSnapping: false,
               allowImplicitScrolling : true ,
                physics: BouncingScrollPhysics(),
                controller: boardController,
                onPageChanged: (int index){
                  if(index == boardingData.length-1) {
                    setState(() {
                      isLast = true ;
                    });
                    Future.delayed(Duration(milliseconds: 800,),()=>
                       Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.rightToLeft,curve: Curves.easeIn, duration: Duration(milliseconds: 1050),
                       child: LoginScreen())),);
                    CacheHelper.saveData(
                   key: 'onBoarding', 
                   value: true);
                  }else {
                    setState(() {
                      isLast = false ;
                    });
                  }
                },
             //clipBehavior: Clip.antiAlias,
                itemBuilder: (context, index) => builfBoardingItem(index:index , boardingData:boardingData ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                   count: boardingData.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey ,
                    activeDotColor: defaultColor,
                    dotHeight: 9 ,
                    spacing: 6.0,
                    expansionFactor: 3 ,
                  ) ,
                   ),
                Spacer(),
                FloatingActionButton(
                    child: Icon(Icons.arrow_forward_ios),
                     onPressed: () 
                     {
                         if (!isLast){
                         boardController.nextPage(
                           duration: Duration(milliseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn);
                       } else {
                  CacheHelper.saveData(
                   key: 'onBoarding', 
                   value: true);
                  //  .then((value) {
                  //    if(value)
                  //    {
                  //      Navigator.of(context).pushReplacement(PageTransition(type: PageTransitionType.fade, 
                  //     child: RegisterScreeen()));
                  //    }
                  //  }) ;
                      }
                     }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget builfBoardingItem({int index , List<BorardingModel>boardingData}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PageView.builder(
          //   itemBuilder: itemBuilder
          //   )
          Expanded(
              child: Image(image: AssetImage(boardingData[index].image) ,)),
          Text(
            '${boardingData[index].title}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            '${boardingData[index].body}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      );
  
  
  

}


