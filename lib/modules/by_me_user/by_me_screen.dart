import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/layout/home_cubit/home_states.dart';
import 'package:zenon/modules/by_me_user/nfc_barCode_red_write/nfc_screen.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/shared/styles/colors.dart';

import 'by_me_cart_screen.dart';
import 'by_me_cubit/by_me_cubit.dart';
import 'by_me_cubit/by_me_stetes.dart';
import 'market_bill_screen.dart';
class ByMeScreen extends StatefulWidget {
  @override
  _ByMeScreenState createState() => _ByMeScreenState();
}

class _ByMeScreenState extends State<ByMeScreen> {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
  void initState() {
ByMeCubit.get(context).getProductDataFromFirebaseandFiltered();
ByMeCubit.get(context).checkNfcTurnOn();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var homeCubit = HomeCubit.get(context);
    return MultiBlocListener(
      listeners: [
      BlocListener<ByMeCubit ,ByMeCubitStates>(listener: (context , state ){
        
      }),
      BlocListener<HomeCubit ,HomeStates>(listener: (context , state ){
         if(state is UserAlreadySigninState)
          {
            
                homeCubit.isSignin = true;
              
          }
          if(state is UserNotSigninYetState)
          {
            builAlertDialogForAlertUserToSignin(ctx: context);
          }

      } ,),],
      child:  Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('By Me'),
          centerTitle: true,
          
        ),
        body:Padding(
          padding: const EdgeInsets.only(bottom:60),
          child: SingleChildScrollView(
                      child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width*0.9,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                   // fit: BoxFit.fill,
                    image: AssetImage('assets/images/zenonNfc.png'),
                    //'assets/images/emptyCart.png'
                  )),
                ),
              ),
              Text(
                'Here, you can account up\n yourself by yourself',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Please select which way you prefer \n to scan items of your order',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 20,
                      color: isdarkTheme ? Colors.white70 : Colors.grey[600],
                    ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //nfc button
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        homeCubit.checkIfUserLogInOrGest();
                        if(homeCubit.isSignin)
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ByMeCartScreen(isNfc: true,)));
                      },
                      style: ElevatedButton.styleFrom(
                        primary:defaultColor,
                        
                        // Colors.redAccent
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.green , width: 2),
                        ),
                      ),
                      icon: Icon(
                        Icons.nfc_rounded,
                        color: Colors.green,
                      ),
                      label: Text(
                        'NFC',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),
                  //barcode button
                    Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.05,
                child: ElevatedButton.icon(
                  onPressed: () {
                    homeCubit.checkIfUserLogInOrGest();
                    if(homeCubit.isSignin)
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ByMeCartScreen(isBarcode: true,)));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: defaultColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.green , width: 2),
                    ),
                  ),
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.green,
                  ),
                  label: Text(
                    'Barcode',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                  ),
                ),
              ) ,
            
                ],
              ) ,
               SizedBox(height: 10,),
                Container(
                width: MediaQuery.of(context).size.width * 0.737,
                height: MediaQuery.of(context).size.height * 0.05,
                child: ElevatedButton.icon(
                  onPressed: () {
                   showAlertDialog(_scaffoldKey.currentContext);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: defaultColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.green , width: 2),
                    ),
                  ),
                  icon: Icon(
                    Icons.where_to_vote_outlined,
                    color: Colors.green,
                  ),
                  label: Text(
                    'Just inquiry about my bill',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                  ),
                ),
              ) ,
            
            ],
      ),
          ),
        ),
        
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
           
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MarketCustomerBill(),));
          }, 
          label: Row(
            children: [
              Icon(Icons.list),
              SizedBox(width: 5,),
              Text('My Bill' , style: TextStyle(fontWeight: FontWeight.w600),)
            ],
          )),

           
      )
     ,

    );
      
     
    
           
  }

  showAlertDialog(BuildContext ctx ){
     showDialog(context: ctx,
       builder: (context )
       {
         return AlertDialog(
           title:Row(
         children: [
           Icon(Icons.article_outlined,
           color: Colors.green,
           size: 30,),

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text('inquiry about bill' ,style: TextStyle(fontWeight: FontWeight.w700),)
           ),


          


         ],
       ), 
            
            content:  Text('Please select which way you prefer \n to scan items of your order' ,style: TextStyle(fontWeight: FontWeight.w600)) ,

              actions:
        [ 
           TextButton(onPressed: () {
              Navigator.of(context).canPop()? Navigator.of(context).pop():null;
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ByMeCartScreen(isBarcode: true, isJustInquiry: true)));
             
            
           } , child: Text('Barcode' , style: TextStyle(fontWeight: FontWeight.w500 , color: Colors.red),)),
          TextButton(onPressed: (){
             Navigator.of(context).canPop()? Navigator.of(ctx).pop():null;
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ByMeCartScreen(isNfc: true,isJustInquiry: true,)));
           
          }, child: Text('NFC' ,style: TextStyle(fontWeight: FontWeight.w500))),
        ],
     
            
         
         );

       }
       );  
   
  }

   builAlertDialogForAlertUserToSignin({BuildContext ctx}) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.person_add,
                  color: Colors.red,
                  size: 30,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )),
              ],
            ),
           contentPadding: const EdgeInsets.fromLTRB(24.0, 10, 24.0, 15) ,
            actions: [

              TextButton(
                  onPressed: () {
                    Navigator.of(context).canPop()?Navigator.of(context).pop():null ;
                    Navigator.pushReplacementNamed(context, '/loginScreen');
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.green),
                  )),
              TextButton(
                  onPressed: () {
                    // Navigator.of(context).canPop()?Navigator.of(context).pop():null ;
                    Navigator.pushReplacementNamed(context, '/signUpScreen');
                  },
                  child: Text('Sign Up',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.green[400]))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).canPop()?Navigator.of(context).pop():null ;
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.red),
                  )),
            ],
            scrollable: true,
            content: Column(children: [
              Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 8.0),
                  child: Text(
                    'To continue you must register your Account on our APP',
                    style: TextStyle(fontWeight: FontWeight.w600 , color: Colors.red),
                  )),
                  SizedBox(height: 6,),
                 Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 8.0),
                  child: Text(
                    'please, Click Sign in or Sign Up',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
                
                

               ]),
          );
        });
  }
}