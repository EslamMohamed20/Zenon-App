
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/layout/home_cubit/home_states.dart';
import 'package:zenon/modules/cart/cubit/cart_cubit.dart';
import 'package:zenon/modules/cart/cubit/cart_states.dart';
import 'package:zenon/shared/components/components.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/shared/styles/colors.dart';

import 'by_me_cubit/by_me_cart_model.dart';
import 'by_me_cubit/by_me_cubit.dart';
import 'by_me_cubit/by_me_stetes.dart';
import 'nfc_barCode_red_write/barcode_screen.dart';
import 'nfc_barCode_red_write/nfc_screen.dart';

class ByMeCartScreen extends StatefulWidget {
  final bool isNfc;
  final bool isBarcode;
  final bool isJustInquiry;

   ByMeCartScreen({ this.isNfc =false, this.isBarcode=false, this.isJustInquiry = false});

  @override
  _ByMeCartScreenState createState() => _ByMeCartScreenState();
}

class _ByMeCartScreenState extends State<ByMeCartScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController cardIdController = TextEditingController();
  GlobalKey<FormState> form2Key = GlobalKey<FormState>();
  bool isBottomSheetShow = true ;
 
 


  @override
  Widget build(BuildContext context) {
    var cubit = ByMeCubit.get(context);
    var homeCubit = HomeCubit.get(context);
    
     
    return MultiBlocListener(
      listeners: [
      BlocListener<ByMeCubit ,ByMeCubitStates>(listener: (context , state ){
        if (state is UploadByMeOrderWithCardConfirmationToFirebaseSuccessState )
         {
           
          builAlertDialogForOrderDoneSuccessfully(ctx: context , cubit:cubit );
         }
           
      }),
      BlocListener<HomeCubit ,HomeStates>(listener: (context , state )async {
         if (state is CheckIfThisUserCardIdFoundInOurDatabaseSuccessState)
                      {
                         await  homeCubit.updateUserDataOnFirebase(
                                          zenonCardId:cardIdController.text,
                                        );
                         await  homeCubit.getUserDataFromFirebase();
                          await  cubit.setOrderConfermationCardIDAndTotalAmountRealtimeDatabase(cardId: homeCubit.userModlInfo.zenonCardId,
                          totalAmount:cubit.total );
                         await cubit.uploadByMeOrderWithCardConfirmationToFirebase(zenonCardId:homeCubit.userModlInfo.zenonCardId ,
                         orderNumber:homeCubit.userModlInfo.zenonCardId ,
                         orderDone: true , 
                         totalAmount: cubit.total );
                       

                    
                      }
           if (state is CheckIfThisUserCardIdFoundInOurDatabaseErrorState)
                      {
                          Toast.show('This Card not supported from us', context ,backgroundColor: Colors.red , duration: 3 );
                      }
          if(state is UserAlreadySigninState)
          {
              setState(() {
                homeCubit.isSignin = true;
              });
          }
          
      }),
    ]
    , child: Scaffold(
          key: _scaffoldKey,
      appBar: AppBar(
        
        backgroundColor:  defaultColor,
        leading: IconButton(icon: Icon(Feather.arrow_left , color: Colors.white,), onPressed: (){
         // cubit.removeAllItemFromCart();
          Navigator.of(context).canPop()?Navigator.of(context).pop():null;
        }),
        title: Text('My Cart'),centerTitle: true,
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle.copyWith(color: Colors.white ,
            shadows:[
              Shadow(color: Colors.redAccent , blurRadius: 5 , offset: Offset(0.2 , 0.7)),
            ] ),
       
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () async
            {
                await defaultAlertDialog(title: 'Delete all items' , subTitle: 'Are you sure to empty your cart ?' ,
                                  context: context , fun: (){
                                   cubit.removeAllItemFromCart();
                                  
                                  }
                                  );
              
            },
            icon: Icon(Feather.trash),
          ),
        ],
      ),
    
      bottomSheet: checkoutSection(context  ,cubit  , homeCubit),
      
      body: scanScreen(context),
    ),

    
    );
    
 
    
  
  }

   Widget checkoutSection (BuildContext context , ByMeCubit cubit  , HomeCubit homeCubit) {
    return BlocConsumer<ByMeCubit ,ByMeCubitStates>(
      listener: (context , state ){},
      builder:  (context , state ){
        return Container(

        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(top:  BorderSide(color: Colors.grey , width: 0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Row (
            crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(!widget.isJustInquiry)
              Expanded(
                flex: 5,
                child: Material(
                  color: defaultColor,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.redAccent),
                  ),
                  child: InkWell(
                    onTap: ()async{
                      if(cubit.cartItems.isNotEmpty){
                      builAlertDialogForAskCustomerCompleteHisOrderOrNot(ctx: _scaffoldKey.currentContext ,
                      cubit:cubit , homeCubit: homeCubit );

                      }else{
                     Toast.show('YourCart Is Empty', context , duration: 2 , backgroundColor: Colors.red);
                      }
                     
                    
                      


                    },
                      borderRadius: BorderRadius.circular(30),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Checkout' ,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white ,
                       fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
              if(!widget.isJustInquiry)
              Spacer(),
              Text('Total:' , 
                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20)
              ),
              SizedBox(width: 2.5,),
              Text('${cubit.total.toStringAsFixed(2)}' ,

                style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontFamily:'',
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  fontSize: 22,
                  color: isdarkTheme?Colors.blue : defaultColor,

                ),
              ),
              SizedBox(width: 1.5,),
              Text(
                'EGP',
                style: Theme.of(context).textTheme.caption
                    .copyWith(
                  fontFamily:'',
                  fontWeight: FontWeight.w500,
                  color: isdarkTheme?Colors.blue : defaultColor,
                  height: 2,
                ),
              ),
              SizedBox(width: 10,),

            ],
          ),
        ),
      );
    
      },
          );
   }

  Widget scanScreen (BuildContext ctx){
    if (widget.isNfc)
    {
      return  NfcScreen(scaffoldKey: _scaffoldKey);
    }
    if(widget.isBarcode)
    {
    return  BarcodeScreen();
    }
    
      
    }
 
  builAlertDialogForAddNewCard({BuildContext ctx, HomeCubit cubit}) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.payment,
                  color: Colors.red,
                  size: 30,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Add your Zenon card ID',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )),
              ],
            ),
           contentPadding: const EdgeInsets.fromLTRB(24.0, 10, 24.0, 15) ,
            actions: [

              TextButton(
                  onPressed: ()async {
                    if (form2Key.currentState.validate()) {
                      Navigator.of(context).canPop()?Navigator.of(context).pop():null;
                      await cubit.getAuthsZenonCardsFromFirebase();
                      await cubit.checkIfThisUserCardIdFoundInOurDatabase(cardIdController.text);
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.green),
                  )),
              TextButton(
                  onPressed: () {
                  
                  cardIdController.clear();
          
                    Navigator.of(ctx).pop();
                  },
                  child: Text('Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.red))),
            ],
            scrollable: true,
            content: Form(
              key: form2Key,
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.symmetric( horizontal: 8.0),
                    child: Text(
                      'To continue you must register your zenon card ID.',
                      style: TextStyle(fontWeight: FontWeight.w600 , color: Colors.red),
                    )),
                   Row(
                     children: [
                       Padding(
                        padding: const EdgeInsets.symmetric( horizontal: 8.0),
                        child: Text(
                          'please, Enter your ID or Scan it',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )),
                        Icon(Icons.nfc_rounded),
                     ],
                   ),
                  
                   //cardId
                SizedBox(
                  height: 8,
                ),
                Row(
                    children: [
                      Expanded(
                        child: DefaultFormField(
                            controller:cardIdController,
                            keyboardType: TextInputType.text,
                            label: 'Zenon Card ID',
                            hint: 'Enter the ID',
                            prefixIcon: Icon(Icons.payment),
                            textColor: defaultColor,
                            fontSize: 15,
                            textWeight: FontWeight.w600,
                            onSubmit: (value){
                             cardIdController.text =value;
                            },
                            validator: (value) {
                              if (value.isEmpty ||
                value.contains('/') ||
                value.contains('*') ||
                value.contains('#') ||
                value.contains('\$')) {
                                return 'please enter a valid Card ID ,\nIt must be not empty';
                              } else if (value.length != 8) {
                                return 'Card ID Must be 8 digits no more or less';
                              }
                            }),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(width: 1),
                        ),
                        child: IconButton(
                            icon: Icon(Icons.nfc_rounded),
                            iconSize: 30,
                            onPressed: () async => nfcReadResponse(
                                ctx: context,
                                homeCubit: cubit,
                                supportsNFC: await cubit.checkNfcTurnOn())),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 6,
                ),

                 ]),
            ),
          );
        });
  }

  nfcReadResponse(
      {BuildContext ctx, bool supportsNFC, HomeCubit homeCubit}) async {
    if (!supportsNFC) {
      await defaultAlertDialog(
          title: 'NFC Alert',
          subTitle:
              "To continue, turn on NFC in your device Or scan your items with BarCode",
          context: ctx,
          showSeconedBUTTON: false);
    } else {
      await showDialog(
          context: ctx,
          builder: (context) {
            Stream<NDEFMessage> _stream = NFC.readNDEF(once: true);

            //  _stream = NFC
            //         .readNDEF(
            //             once: true,
            //             throwOnUserCancel: false,
            //             alertMessage: 'readed'
            //             )
            _stream.listen(
              (
                NDEFMessage message,
              ) {
                print("read NDEF message: ${message.id}");
               
              //  List dataSplited = message.data.split(" ");
               // print(dataSplited);
                homeCubit.tagInfo = {
                  'tagId': message.id,
                  'productName': '',
                  'productPrice': 0,
                  'productFullNameOnTag':'' ,
                };
                homeCubit.tagInformation = TagModel.fromJson(homeCubit.tagInfo);
                //  print('productName : ${tagInfo['productName']}');
                //  print('productPrice : ${tagInfo['productPrice']}');
                print('TagId : ${homeCubit.tagInformation.tagId.toString()}');
              },
              onError: (error) {
                // Check error handling guide below
                print("read NDEF message: ${error.toString()}");
                Toast.show('${error.toString()}', ctx,
                    gravity: 1, duration: 4, backgroundColor: Colors.red);
              },
              onDone: () {
                print('done');
                setState(() {
                  cardIdController.clear();
                  cardIdController.text =
                      homeCubit.tagInformation.tagId;
                  if (cardIdController.text.length == 8)
                    print('done: ${cardIdController.text}');
                });
                //  _stream.pause();  => if   StreamSubscription<NDEFMessage> _stream;
                Navigator.of(context).pop();
              },
            );

            return AlertDialog(
              scrollable: true,
              title: Row(
                children: [
                  Icon(
                    Icons.nfc,
                    color: Colors.green,
                    size: 30,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Scan Your Card',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                ],
              ),
              actions: [
                //     TextButton(onPressed: () {
                //        //----------------------
                //    Navigator.of(context).pop();
                //  } ,
                // child: Text('Yes' , style: TextStyle(fontWeight: FontWeight.w500 , color: Colors.red),)),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel',
                        style: TextStyle(fontWeight: FontWeight.w500))),
              ],
              content: Column(
                children: [
                  Text(
                    'Please Put your phone above your Zenon card',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Image(
                    image: AssetImage('assets/images/zenonNfc.png'),
                    height: 230,
                    width: 230, fit: BoxFit.fill,
                    //MediaQuery.of(context).size.width*0.6,fit: BoxFit.fill,
                  ),
                ],
              ),
            );
          });
    }
    // return RaisedButton(
    //     child: Text(_reading ? "Stop reading" : "Start reading"),
    //     onPressed: () {
    //       if (_reading) {
    //         _stream?.cancel();

    //         setState(() {
    //           _reading = false;
    //         });
    //       } else {
    //         setState(() {
    //           _reading = true;
    //           // Start reading using NFC.readNDEF()
    //           });
    //       }
    //     });
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
                    Navigator.pushReplacementNamed(context, '/loginScreen');
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.green),
                  )),
              TextButton(
                  onPressed: () {
                   
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

builAlertDialogForAskCustomerCompleteHisOrderOrNot({BuildContext ctx ,  ByMeCubit cubit , HomeCubit homeCubit}) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: Colors.red,
                  size: 30,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Alert',
                      style: TextStyle(fontWeight: FontWeight.w700 ,),
                    )),
              ],
            ),
           contentPadding: const EdgeInsets.fromLTRB(24.0, 10, 24.0, 15) ,
            actions: [
               TextButton(
                  onPressed: () async{
                    Navigator.of(context).canPop()?Navigator.of(context).pop():null ;

                     await  homeCubit.getUserDataFromFirebase();
                      homeCubit.checkIfUserLogInOrGest();
                      if(homeCubit.isSignin){
                        print(homeCubit.isSignin);
                      if(homeCubit.userModlInfo.zenonCardId.isNotEmpty && homeCubit.userModlInfo.zenonCardId.length==8 &&
                       homeCubit.userModlInfo.zenonCardId!=null &&  homeCubit.userModlInfo.zenonCardId != '0' &&  homeCubit.userModlInfo.zenonCardId !=''
                        && homeCubit.userModlInfo.zenonCardId.toLowerCase()!='unknown')
                        {
                          print ('from checkout section : payment succesfully');
                           await  cubit.setOrderConfermationCardIDAndTotalAmountRealtimeDatabase(cardId: homeCubit.userModlInfo.zenonCardId,
                          totalAmount:cubit.total );
                         await cubit.uploadByMeOrderWithCardConfirmationToFirebase(zenonCardId:homeCubit.userModlInfo.zenonCardId ,
                         orderNumber:homeCubit.userModlInfo.zenonCardId ,
                         orderDone: true , 
                         totalAmount: cubit.total );
                        }
                        else 
                        {
                          print ('from checkout section : payment Faliled');
                          builAlertDialogForAddNewCard(ctx:_scaffoldKey.currentContext , cubit: homeCubit );

                        }
                      }
                      else {print( homeCubit.isSignin);
                      builAlertDialogForAlertUserToSignin(ctx: _scaffoldKey.currentContext);}

                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color:defaultColor),
                  )),
               TextButton(
                  onPressed: () {
                    Navigator.of(context).canPop()?Navigator.of(context).pop():null ;
                  },
                  child: Text(
                    'Back to cart',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color:Colors.red),
                  )),
            ],
            scrollable: true,
            content: Column(children: [
              Padding(
                 padding: const EdgeInsets.symmetric( horizontal: 8.0),
                  child: Text(
                    'Are You Ready To Complete Your Order?',
                    style: TextStyle(fontWeight: FontWeight.w600 , color: defaultColor),
                  )),

               ]),
          );
        });
  }


builAlertDialogForOrderDoneSuccessfully({BuildContext ctx , ByMeCubit cubit }) {
    showDialog(
        context: ctx,
        builder: (context) {
          String orderNumber =HomeCubit.get(context).userModlInfo.zenonCardId;
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: Colors.green,
                  size: 30,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Congratulations',
                      style: TextStyle(fontWeight: FontWeight.w700 ,),
                    )),
              ],
            ),
           contentPadding: const EdgeInsets.fromLTRB(24.0, 10, 24.0, 15) ,
            actions: [
               TextButton(
                  onPressed: () {
                    Navigator.of(context).canPop()?Navigator.of(context).pop():null ;
                    builAlertDialogForNoteUserMoreInformationAndCheckOutWithNfc(ctx:context );
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color:defaultColor),
                  )),
                ],
            scrollable: true,
            content: Column(children: [
              Padding(
                 padding: const EdgeInsets.symmetric( horizontal: 8.0),
                  child: Text(
                    'Your order is done successfully',
                    style: TextStyle(fontWeight: FontWeight.w600 , color: defaultColor),
                  )),
                  SizedBox(height: 5,),
                
              Image(image: AssetImage('assets/images/orderComplete.png'),
              width: MediaQuery.of(context).size.width*0.6,
              height: MediaQuery.of(context).size.width*0.43 ,),
              SizedBox(height: 15,),
              // order number
              Padding(
                 padding: const EdgeInsets.symmetric( horizontal: 8.0),
                 
                  child: Row(
                    children: [
                      Text(
                        'Order Number:',
                        style: TextStyle(fontWeight: FontWeight.w600 ,),
                      ),
                      SizedBox(width: 3,),
                      Text(
                        '$orderNumber',softWrap: true,maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w600 , color: defaultColor , fontFamily: ''),
                      ),
                     
                    ],
                  )),
              SizedBox(height: 10,),
               // cardId
              Padding(
                 padding: const EdgeInsets.symmetric( horizontal: 8.0),
                 
                  child: Row(
                    children: [
                      Text(
                        'Card ID:',
                        style: TextStyle(fontWeight: FontWeight.w600 ,),
                      ),
                      SizedBox(width: 3,),
                      
                      Text(
                        '${HomeCubit.get(context).userModlInfo.zenonCardId}',
                        style: TextStyle(fontWeight: FontWeight.w600 , color: defaultColor, fontFamily: ''),
                      ),
                     
                    ],
                  )),
              SizedBox(height: 10,),
              //total amount //cubit.total.toStringAsFixed(2)
              Padding(
                 padding: const EdgeInsets.symmetric( horizontal: 8.0),
                 
                  child: Row(
                    children: [
                      Text(
                        'Total Amount:',
                        style: TextStyle(fontWeight: FontWeight.w600 ,),
                      ),
                      SizedBox(width: 4,),
                      
                      Text(
                        '${cubit.total.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.w600 ,fontFamily: '',
                         color: defaultColor),
                      ),
                      SizedBox(width: 2,),
                      Text(
                        'L.E',
                        style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 12),
                      ),
                     
                    ],
                  )),
              //total amount //cubit.total.toStringAsFixed(2)
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 8.0),
                  child: Text(
                    'Thank you For shopping With Us',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
                
              

               ]),
          );
        });
  }

builAlertDialogForNoteUserMoreInformationAndCheckOutWithNfc({BuildContext ctx ,}) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.red,
                  size: 30,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'More Information',
                      style: TextStyle(fontWeight: FontWeight.w700 ,),
                    )),
              ],
            ),
           contentPadding: const EdgeInsets.fromLTRB(24.0, 10, 24.0, 15) ,
            actions: [
               TextButton(
                  onPressed: () async{
                    Navigator.of(context).canPop()?Navigator.of(context).pop():null ;
                      nfcWriteTotalPriceTocheckoutFromCustomerPhone(ctx:context  , 
                       byMeCubit: ByMeCubit.get(context) , homeCubit: HomeCubit.get(context),
                        supportsNFC:await ByMeCubit.get(context).checkNfcTurnOn()  );
                  }
                  ,
                  child: Text(
                    'Checkout with my phone',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color:defaultColor),
                  )),
               //cancel
               TextButton(
                  onPressed: () {
                    
                    ByMeCubit.get(context).removeAllItemFromCart();
                    Navigator.of(context).canPop()?Navigator.of(context).pop():null ;
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color:Colors.red),
                  )),
            ],
            scrollable: true,
            content: Column(children: [
              Padding(
                 padding: const EdgeInsets.symmetric( horizontal: 8.0),
                  child: Text(
                    'Congratulations, Now you able to exit from our market freely,',
                    style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 18 , color: defaultColor ),
                  )),
              SizedBox(height: 8,),
              Padding(
                 padding: const EdgeInsets.symmetric( horizontal: 8.0),
                  child: Text(
                    'All you need to pass your Zenon card above the specified place at the checkout cabinet,',
                    style: TextStyle(fontWeight: FontWeight.w600 ,  fontSize: 15 ,height: 1.3 ),
                   softWrap: true ,)),
                   SizedBox(height: 3,),
               Padding(
                 padding: const EdgeInsets.symmetric( horizontal: 8.0),
                  child: Text(
                    'Or If your phone supported NFC thus,  you can Checkout with your phone just click \'Checkout with my phone\'.',
                    style: TextStyle(fontWeight: FontWeight.w600  , fontSize: 15 ,height: 1.3  ),
                   softWrap: true ,)),
              ]),
          );
        });
  }







   nfcWriteTotalPriceTocheckoutFromCustomerPhone ({BuildContext ctx , bool supportsNFC ,ByMeCubit byMeCubit , HomeCubit homeCubit
   }) async {
     
     if (!supportsNFC) {
    await  defaultAlertDialog(title: 'NFC Alert' ,
     subTitle: "To continue, turn on NFC in your device Or scan your items with BarCode",
     context:context , 
    showSeconedBUTTON: false);
    }
    else {
     await  showDialog(context: ctx, 
      builder: (context)  {
        
          Stream<NDEFMessage> _stream =  NFC.readNDEF( once: true);
          
         //  stream.resume();
                  _stream.listen(
                      (NDEFMessage message, )async {
                NDEFMessage newMessage = NDEFMessage.withRecords([
                  NDEFRecord.text(byMeCubit.total.toString())
                    ],  id: homeCubit.userModlInfo.zenonCardId
                  );
                 // message.tag.write(newMessage);
          
          byMeCubit.nfcStream = 
             NFC.writeNDEF(newMessage , once: true ,).listen((NDEFTag tag) {
             print("wrote to tag");});
              //});
         // await NFC.writeNDEF(newMessage , once: true ,).first;
          
            //  stream.listen((NDEFTag tag) {
            //        print("wrote to tag");});
                 },
             cancelOnError: true
                   , onError: (error) {
                  // Check error handling guide below
                 
                  print("read NDEF message: ${error.toString()}");
                  Toast.show('${error.toString()}', ctx ,  gravity: 1 , duration: 4 , backgroundColor: Colors.red);
                },
                 onDone: () {
                  print('done');
                   //stream.cancel();
                  
                   ByMeCubit.get(context).removeAllItemFromCart();
                   Navigator.of(context).canPop()?
                   Navigator.of(context).pop():null;
                   Toast.show('Thank you for shopping with us', context , backgroundColor: Colors.green , duration: 3);
                },
                
                );
             
          
        return AlertDialog(
          scrollable: true,
         title: Row(
         children: [
           Icon(Icons.nfc,
           color: Colors.green,
           size: 30,),

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text('Phone Checkout' ,style: TextStyle(fontWeight: FontWeight.w700),)
           ),


         ],
       ),
           actions: [
          TextButton(onPressed: (){
           
            ByMeCubit.get(context).removeAllItemFromCart();
                    Navigator.of(context).canPop()?Navigator.of(context).pop():null ;
          }, child: Text('Cancel' ,style: TextStyle(fontWeight: FontWeight.w500))),
        
           ],
           content:Column (
               children: [
                 Text('Please put your phone on Zenon label on the checkout cabinet' ,
                 style:  TextStyle(fontWeight: FontWeight.w600),),
                 SizedBox(height:10 ,),
                 Image(image: AssetImage('assets/images/zenonNfc.png')
                 ,height: 230,
                 width: 230
                 , fit: BoxFit.fill,
                 //MediaQuery.of(context).size.width*0.6,fit: BoxFit.fill,
                 ),
                 
               ],
             ) ,

           
        );
      }
      );
    }

   }

 
 
 
 
  }
