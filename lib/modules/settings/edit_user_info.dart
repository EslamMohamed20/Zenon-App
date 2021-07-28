

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:toast/toast.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/layout/home_cubit/home_states.dart';
import 'package:zenon/modules/by_me_user/by_me_cubit/by_me_cubit.dart';
import 'package:zenon/shared/components/components.dart';
import 'package:zenon/shared/styles/colors.dart';

class EditUserInfo extends StatefulWidget {
  @override
  _EditUserInfoState createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditUserInfo> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController adress_1Controller = TextEditingController();

  TextEditingController adress_2Controller = TextEditingController();

  TextEditingController zenonCardIDController = TextEditingController();

  @override
  void initState() {
    HomeCubit.get(context).getAuthsZenonCardsFromFirebase();
    super.initState();
  }
 bool isCardIdExist = true;
  @override
  Widget build(BuildContext context) {
    
    return BlocConsumer<HomeCubit , HomeStates>(
      listener:(context ,state){
        if(state is UpdateUserDataInfoSuccessState)
        {
          Toast.show('Updated your profile successfully', context , duration: 3 , backgroundColor: Colors.green);
          HomeCubit.get(context).getUserDataFromFirebase();
        }
        if(state is CheckIfThisUserCardIdFoundInOurDatabaseErrorState)
        {
            setState(() {
               isCardIdExist = false ;
            });
        }
        if(state is CheckIfThisUserCardIdFoundInOurDatabaseSuccessState)
        {
            setState(() {
               isCardIdExist = true ;
            });
        }
      } ,
      builder:(context ,state){
        var cubit=HomeCubit.get(context);
        nameController.text =nameController.text.isEmpty? cubit.userModlInfo.name:nameController.text;
        phoneController.text = phoneController.text.isEmpty? cubit.userModlInfo.phone:phoneController.text ;
        adress_1Controller.text =adress_1Controller.text.isEmpty? cubit.userModlInfo.adress_1: adress_1Controller.text;
        adress_2Controller.text = adress_2Controller.text.isEmpty?cubit.userModlInfo.adress_2 :adress_2Controller.text ;
       zenonCardIDController.text = zenonCardIDController.text.isEmpty?cubit.userModlInfo.zenonCardId :zenonCardIDController.text ;
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Edit Profile'),
          ),
        body: ConditionalBuilder(
          condition: state is! GetUserDataLoadingStates,
          builder:(context)=>Form(
            key: formKey,
                  child: SingleChildScrollView(
                                    child: Container(
                      padding:EdgeInsets.symmetric(horizontal: 25 , vertical: 12) ,
                      child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                     border: Border.all(width: 4 , color: defaultColor),
                     borderRadius: BorderRadius.circular(100)
                    ),
                    child: CircleAvatar(
                      backgroundImage: cubit.pickedImage==null? NetworkImage(cubit.userModlInfo.image )
                      : FileImage(cubit.pickedImage),
                     // foregroundColor: Colors.grey[50],
                      backgroundColor:Colors.grey[50] ,
                      radius: 100,
                      child: InkWell(
                        onTap: ()
                        {
                          cubit.getImage(src: ImageSource.gallery ,
                                            uploadChildFolderName: nameController.text , 
                                            uploadMainFolderName: 'usersImages');
                        },
                          child: Align(
                           alignment: Alignment.bottomRight,
                                      child: CircleAvatar(
                            child: Icon(Icons.add_a_photo_outlined),
                            radius: 28,
                        ),
                          ),
                      ),
                    ),
                ),
                if(state is UploadImagesToFirebaseStorageAndGetLinkLoadingState)
                 SizedBox(height: 10,),
                if(state is UploadImagesToFirebaseStorageAndGetLinkLoadingState)
                LinearProgressIndicator(),
                if(state is UploadImagesToFirebaseStorageAndGetLinkLoadingState)
                SizedBox(height: 5,),
                if(state is UploadImagesToFirebaseStorageAndGetLinkLoadingState)
                Text('Uploading your photo' , style: TextStyle(fontWeight: FontWeight.w500 , color: Colors.red),),
                SizedBox(height: 30,),
                 //name---------------------------------
                                     DefaultFormField(
                                                controller: nameController,
                                                keyboardType: TextInputType.name,
                                                label: 'Name',
                                                hint: '${cubit.userModlInfo.name}',
                                                prefixIcon:Icon(Icons.person),
                                                textColor: defaultColor,
                                                fontSize: 15,
                                                textWeight: FontWeight.w600,
                                                validator: (value) {
                                                  if (value.isEmpty || value.contains('/') ||value.contains('*') ||value.contains('#')  ||value.contains('\$')) {
                                                    return 'please enter a valid name';
                                                  }
                                                }),
                                         SizedBox(
                                      height: 15,
                                    ),
                                    //phone
                                      DefaultFormField(
                                                  controller: phoneController,
                                                  keyboardType: TextInputType.phone,
                                                  label: 'Phone',
                                                  hint: '${cubit.userModlInfo.phone}',
                                                  textColor: defaultColor,
                                                  fontSize: 15,
                                                  textWeight: FontWeight.w600,
                                                  prefixIcon: Icon(Icons.phone),
                                              //  inputFormatter: FilteringTextInputFormatter.digitsOnly,
                                                  validator: (value) {
                                                    if (value.isEmpty ) {
                                                      return 'please enter your phone';
                                                    }
                                                    if (value.length != 11 &&  value.length != 8) {
                                                      return 'please enter a valid Phone';
                                                    }return null;
                                                  }),
                                           SizedBox(
                                        height: 15,
                                      ),
                                //adress 1
                                 DefaultFormField(
                                                controller: adress_1Controller,
                                                keyboardType: TextInputType.streetAddress,
                                                label: 'Adress1',
                                                hint: '${cubit.userModlInfo.adress_1}',
                                                prefixIcon:Icon(Icons.local_shipping_outlined),
                                                textColor: defaultColor,
                                                fontSize: 15,
                                                textWeight: FontWeight.w600,
                                                validator: (value) {
                                                  if (value.isEmpty||value.contains('*') ||value.contains('#')  ||value.contains('\$')) {
                                                    return 'please enter a valid adress';
                                                  }
                                                }),
                                         SizedBox(
                                      height: 15,
                                    ),
                                    //adress2
                                     DefaultFormField(
                                                controller: adress_2Controller,
                                                keyboardType: TextInputType.streetAddress,
                                                label: 'Adress2',
                                                hint: '${cubit.userModlInfo.adress_2}',
                                                prefixIcon:Icon(Icons.local_shipping_outlined),
                                                textColor: defaultColor,
                                                fontSize: 15,
                                                textWeight: FontWeight.w600,
                                                validator: (value) {
                                                  if (value.contains('*') ||value.contains('#')  ||value.contains('\$')) {
                                                    return 'please enter a valid adress';
                                                  }
                                                }),
                                         SizedBox(
                                      height: 15,
                                    ),
                                    //zenonCardIDController
                                     Row(
                                       children: [
                                         Expanded(
                                         child: DefaultFormField(
                                                      controller:zenonCardIDController ,
                                                      keyboardType: TextInputType.text,
                                                      label: 'Zenon Card ID',
                                                      hint: '${zenonCardIDController.text}',
                                                      prefixIcon:Icon(Icons.person),
                                                      textColor: defaultColor,
                                                      fontSize: 15,obscure: cubit.isPasswordShow,
                                                      suffixIcon: InkWell(
                                                        onTap: (){
                                                          cubit.changePasswordVisibility();
                                                        },
                                                        child: Icon(cubit.suffixIcon),
                                                        ),
                                                      textWeight: FontWeight.w600,
                                                       onChanged: (cardId){
                                                         if(cardId.length==8)
                                                        cubit.checkIfThisUserCardIdFoundInOurDatabase(cardId);
                                                      },
                                                      validator: (value) {
                                                        if (value.isEmpty || value.contains('/') ||value.contains('*') ||value.contains('#')  ||value.contains('\$')) {
                                                          return 'please enter a valid Card ID ,\nIt must be not empty';
                                                        }else if (value.length != 8)
                                                        {
                                                          return 'Card ID Must be 8 digits no more or less' ;
                                                        }
                                                      }),
                                                      
                                         ),
                                         SizedBox(width: 5,),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                border: Border.all(width: 1),
                                              ),
                                              child: IconButton(
                                    icon: Icon(Icons.nfc_rounded),iconSize: 30,
                                    onPressed: () async => nfcReadResponse(
                                        ctx: _scaffoldKey.currentContext,
                                        homeCubit: cubit,
                                        supportsNFC: await cubit
                                              .checkNfcTurnOn())),
                                            ),
                                       ],
                                     ),
                                         SizedBox(
                                      height: 30,
                                    ),

                                        //Save button
                              ConditionalBuilder(
                                condition: state is! UpdateUserDataInfoLoadingState, //الشرط
                                builder: (context) => defaultButton(
                                  function: isCardIdExist? () {
                                    if (formKey.currentState.validate()) {
                                        cubit.updateUserDataOnFirebase(
                                          adress_1: adress_1Controller.text ,
                                          adress_2: adress_2Controller.text,
                                          zenonCardId:zenonCardIDController.text,
                                          imageUrl:  cubit.imageUrl,
                                          name: nameController.text ,
                                          phoneNumber: phoneController.text ,

                                        );
                                    } else
                                      null;
                                  } : (){
                                    Toast.show('This card Id not supported from us', context , backgroundColor: Colors.red  , duration: 3);
                                  },
                                  text: 'Save My Info',
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700),
                                  isUpperCase: true,
                                  background: defaultColor,
                                ),
                                // لو الشرط صح يعمل ايه
                                fallback: (context) =>
                               Center(
                                    child:
                                        CircularProgressIndicator()) ,
                                        
                                         // لو الشرط غلط ماذا يفعل
                              ),
                           //or login-----------
                          
                                      
              ],
            ),
                    ),
                  ),
          ),
          fallback:(context)=> Center(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 5,),
              Text('Getting your data' , style: TextStyle(fontWeight: FontWeight.w600 , color: Colors.red ,
                  fontSize: 15),
             ),
            ],
        ),
          ),
                  ),
      );
   
      } );
          
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
              
                homeCubit.tagInfo = {
                  'tagId': message.id,
                  'productName':'',
                  'productPrice': 0,
                  'productFullNameOnTag':'',
                };
                homeCubit.tagInformation = TagModel.fromJson(homeCubit.tagInfo);
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
                  zenonCardIDController.clear();
                  zenonCardIDController.text = homeCubit.tagInformation.tagId;
                  if(zenonCardIDController.text.length ==8)
                    homeCubit.checkIfThisUserCardIdFoundInOurDatabase(zenonCardIDController.text);
                  print('done: ${ zenonCardIDController.text}');
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
                        'Scan Your Tag',
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
                    'Please Put your phone on Zenon Tag for this product',
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

}