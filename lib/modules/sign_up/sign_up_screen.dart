

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/modules/sign_up/sign_up_cubit/sign_up_cubit.dart';
import 'package:zenon/modules/sign_up/sign_up_cubit/sign_up_states.dart';
import 'package:zenon/shared/components/components.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/shared/network/local/cacheHelper.dart';
import 'package:zenon/shared/styles/colors.dart';

class SignUpScreeen extends StatefulWidget {
  @override
  _SignUpScreeenState createState() => _SignUpScreeenState();
}

class _SignUpScreeenState extends State<SignUpScreeen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

   TextEditingController emailController = TextEditingController();

   TextEditingController passwordController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
   return  BlocProvider(
        create: (BuildContext context) =>SignUpCubit(),
        child: BlocConsumer<SignUpCubit , AppSignUpStates>(
          listener: (BuildContext context, state)
           {
        
              if (state is UserSignUpWithFirebaseEmailSuccesstState) {            
                 Toast.show( 
               'Welcome ^_^', 
               context ,
               duration: 3,
                backgroundColor:defaultColor.withOpacity(0.9),);
                setState(() {
                  userToken = CacheHelper.getData(key: 'token');
                });
                HomeCubit.get(context).getcategoriesData();
                HomeCubit.get(context).getUserData();          
                HomeCubit.get(context).getHomeData();
                 HomeCubit.get(context).getFavoritesData();
                Navigator.of(context).pushReplacementNamed('/HomePage'); 
               
              }
             if (state is UserSignUpWithFirebaseEmailErrortState)  {
              print('screen :${state.error.message}');
              Toast.show( 
               '${state.error.message}', 
               context ,
               duration: 3,
                backgroundColor: Colors.red.withOpacity(0.9),);
            }
             if(state is UserSignUpWithFirebaseGoogleSuccesstState)
            {
              Toast.show( 
               'Welcome Back', 
               context ,
               duration: 3,
                backgroundColor:defaultColor.withOpacity(0.9),);
                setState(() {
                  userToken = CacheHelper.getData(key: 'token');
                });
                 HomeCubit.get(context).getcategoriesData();
                HomeCubit.get(context).getUserData();          
                HomeCubit.get(context).getHomeData();
                HomeCubit.get(context).getFavoritesData().
                    then((value) => Navigator.of(context).pushReplacementNamed('/HomePage'));
            }
            if(state is UserSignUpWithFirebaseGoogleErrorState)
            {
               print('screen :${state.error.message}');
              Toast.show( 
               '${state.error.message}', 
               context ,
               duration: 3,
                backgroundColor: Colors.red.withOpacity(0.9),);
            }

           if (state is AppSignUpErrorState)
            {
               print('screen :${state.error.toString()}');
               Toast.show( 
               '${state.error.toString()}', 
               context ,
               duration: 4,
                backgroundColor: Colors.red.withOpacity(0.9),);
            }
          
         
          

            },
          builder: (BuildContext context, state) { 
            var cubit = SignUpCubit.get(context);
            return Scaffold(
              backgroundColor: Colors.white,
                //appBar: AppBar(),
                body: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5,),
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              alignment: Alignment.topCenter,
                              height: MediaQuery.of(context).size.width * 0.5,
                              //  width: MediaQuery.of(context).size.width *0.6,
                              child: Image.asset('assets/images/zenonLogo.png'),
                            ),
                            Text(
                              'Register',
                              style: Theme.of(context).textTheme.headline4.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                            ),
                            Text(
                              'Register now to our application store \n \t\t\t\t\t\t\t\t\t\tZenon As You Wish🔥 ',

                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    color: Colors.grey[500],height: 1.3,
                                  ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                             //name---------------------------------
                             DefaultFormField(
                                        controller: nameController,
                                        keyboardType: TextInputType.name,
                                        label: 'Name',
                                        hint: 'Eslam....',
                                        prefixIcon:Icon(Icons.person),
                                        textColor: defaultColor,
                                        fontSize: 15,
                                        textWeight: FontWeight.w600,
                                        validator: (value) {
                                          if (value.isEmpty || value.contains('/') ||value.contains('*') ||value.contains('#')  ||value.contains('\$')) {
                                            return 'please enter a valid email';
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
                                        hint: '01*********',
                                        textColor: defaultColor,
                                        fontSize: 15,
                                        textWeight: FontWeight.w600,
                                        prefixIcon: Icon(Icons.email_outlined),
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
                            //email text field------------------------------------
                            DefaultFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                label: 'Email Adress',
                                hint: 'ex:***@zenon.com',
                                prefixIcon: Icon(Icons.email_outlined),
                                fontSize: 16.5,
                                textWeight: FontWeight.w600,
                                textColor: defaultColor,
                                validator: (value) {
                                  if (value.isEmpty || !value.contains('@')) {
                                    return 'please enter a valid email';
                                  }
                                }),
                            SizedBox(
                              height: 15,
                            ),
                            //Password text field
                            DefaultFormField(
                                controller: passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                label: 'Password',
                                hint: '********',
                                prefixIcon:Icon( Icons.lock_outline),
                                obscure: cubit.isPasswordShow,
                                suffixIcon: IconButton(icon: Icon(cubit.suffixIcon),
                                onPressed:() =>
                                    cubit.changePasswordVisibility(), 
                                ),
                                fontSize: 18,
                                textWeight: FontWeight.w600,
                                textColor: defaultColor,
                                
                                // onSubmit: (_) {
                                //   if (formKey.currentState.validate()) {
                                //     cubit.userSignUpData(
                                //         email: emailController.text,
                                //         password: passwordController.text,
                                //          name: nameController.text, 
                                //          phone: phoneController.text, 
                                //          image: cubit.imageUrl,
                                //         context: context
                                //          );
                                //       //     cubit.userSignUpWithFirebaseEmail(
                                //       // email: emailController.text,
                                //       //  password:  passwordController.text ,
                                //       //  context: context);
                                //   } else
                                //     null;
                                // },
                                 validator: (value) {
                                  if (value.isEmpty || value.length < 6) {
                                    return 'please enter a valid password \npassword must be more than 6 digits';
                                  }
                                }),
                            SizedBox(
                              height:15,
                            ),
                             // imagePicker
                             Container(
                               padding: EdgeInsets.fromLTRB(12, 0, 10, 7),
                               decoration: BoxDecoration(
                                 borderRadius:BorderRadius.circular(3) ,
                                 color: Colors.white ,
                                 border: Border.all( color: Colors.grey
                                 )
                                 ,
                               ),

                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                 
                                 children: [
                                   Column(
                                     children: [
                                       Container(
                                         margin: EdgeInsets.only(top: 6),
                                         child: CircleAvatar(radius: 25,
                                           backgroundColor:Colors.grey,
                                         backgroundImage:cubit.pickedImage==null?
                                         NetworkImage('https://cdn1.vectorstock.com/i/thumb-large/62/60/default-av'
                                         'atar-photo-placeholder-profile-image-vector-21666260.jpg' ,
                                         ) 
                                          : FileImage(cubit.pickedImage , scale: 0.9),
                                         ),
                                        
                                       ),
                                       Text('Add Photo☞', style: TextStyle(fontSize:20 
                                       ,fontWeight: FontWeight.w600 , color: Colors.grey[800] ),),
                                     ],
                                   ),
                                   Spacer() ,
                                   //from gallery
                                   Material(
                                        color: Colors.white,
                                         borderRadius: BorderRadius.circular(15),
                                        child: InkWell(
                                       onTap: (){
                                          cubit.getImage(src: ImageSource.gallery ,
                                          uploadChildFolderName: nameController.text , 
                                          uploadMainFolderName: 'usersImages');
                                       },
                                      splashColor: defaultColor.withOpacity(0.3),
                                       borderRadius: BorderRadius.circular(15),
                                         child: Column(
                                           mainAxisSize: MainAxisSize.min,
                                           children: [
                                        IconButton(
                                            color:   Colors.grey[800] ,
                                            padding: EdgeInsets.all(3.0),
                                            iconSize: 30 ,
                                            icon: Icon(Icons.add_a_photo), 
                                            onPressed: (){
                                               cubit.getImage(src:ImageSource.gallery,
                                          uploadChildFolderName: nameController.text , 
                                          uploadMainFolderName: 'usersImages');
                                            }),
                                       Text('From Galery',style: TextStyle(fontWeight: FontWeight.w600,
                                        color: Colors.grey[800])),
                                           ],
                                         ),
                                     ),
                                   ),
                            SizedBox(
                                   width: 30,
                            ),
                            //from camera
                                   Material(
                                      color: Colors.white,
                                         borderRadius: BorderRadius.circular(15),
                                          child: InkWell(
                                        onTap: (){
                                             cubit.getImage(src: ImageSource.camera ,
                                          uploadChildFolderName: nameController.text , 
                                          uploadMainFolderName: 'usersImages');
                                         },
                                        splashColor: defaultColor.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(15),
                                           child: Column(
                                         children: [
                                           IconButton(
                                             color:  Colors.grey[800],
                                             padding: EdgeInsets.all(3.0),
                                             iconSize: 28 ,
                                             icon: Icon(Icons.add_a_photo ,), 
                                             onPressed: (){

                                               cubit.getImage(src: ImageSource.camera ,
                                          uploadChildFolderName: nameController.text , 
                                          uploadMainFolderName: 'usersImages');
                                             }),
                                           Text('From Camera' ,style: TextStyle(fontWeight: FontWeight.w600),),
                                         ],
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           
                             SizedBox(
                              height:15,
                            ),
                            //Register button
                            ConditionalBuilder(
                              condition: state is! AppSignUpLoadingState && state is! UploadImagesToFirebaseStorageAndGetLinkLoadingState, //الشرط
                              builder: (context) => defaultButton(
                                function: () {
                                  if (formKey.currentState.validate()) {
                                    cubit.userSignUpData(
                                         email: emailController.text,
                                        password: passwordController.text,
                                         name: nameController.text, 
                                         phone: phoneController.text,
                                         image: cubit.imageUrl ,
                                         context: context
                                        );
                                    // cubit.userSignUpWithFirebaseEmail(
                                    //   email: emailController.text,
                                    //    password:  passwordController.text ,
                                    //    context: context);
                                  } else
                                    null;
                                },
                                text: 'REGISTER',
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w700),
                                isUpperCase: true,
                                background: defaultColor,
                              ),
                              // لو الشرط صح يعمل ايه
                              fallback: (context) =>
                              state is! UploadImagesToFirebaseStorageAndGetLinkLoadingState? Center(
                                  child:
                                      CircularProgressIndicator()) :
                                      Center(
                                  child:
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('Please waiting until uploading your image \n then press REGISTER',
                                          textAlign: TextAlign.center,
                                           style: TextStyle(fontWeight: FontWeight.w600 , color: Colors.red),),
                                          LinearProgressIndicator(
                                          ),
                                        ],
                                      )), // لو الشرط غلط ماذا يفعل
                            ),
                         //or login-----------
                         SizedBox(
                          height: 20,
                        ),
                          Row(
                         children: [
                           Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Divider(thickness: 2 ,color: defaultColor, ),
                                ),
                           ),
                           Text('Or login with' , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w800),) ,
                            Expanded(
                                child: Padding(
                               padding: const EdgeInsets.only(left: 5),
                               child: Divider(thickness: 2 ,color: defaultColor ),
                             ),
                           ),
                         ],
                       ),
                        SizedBox(
                          height: 9,
                        ),
                    
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlineButton.icon(
                              onPressed: (){
                                //  cubit.userLoginWithFirebaseFacebook();
                                Toast.show('Not supported now', context , backgroundColor: Colors.red , duration: 2);
                              }, 
                              icon: Icon(Feather.facebook , color: defaultColor,), 
                              label: Text('Facebook' , style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 16),),
                              shape:StadiumBorder() ,
                              highlightColor: defaultColor.withOpacity(0.32),
                              borderSide: BorderSide(width: 2 , color:defaultColor, ),),
                        //   SizedBox(
                        //   width: 10,
                        // ),
                           OutlineButton.icon(
                              onPressed: ()
                              {
                                cubit.userSignUpWithFirebaseGoogle(context: context);
                              }, 
                              icon: Icon(Entypo.google_ , color: Colors.redAccent[700],), 
                              label: Text('Google' , style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 16),),
                              shape:StadiumBorder() ,
                              highlightColor: Colors.red.shade200.withOpacity(0.34),
                              borderSide: BorderSide(width: 2 , color:Colors.red, ),),
                          
                          ],
                        ),
                         SizedBox(
                          height: 3,
                        ),
                      
                         
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
  
           },
            ),
   );
}
}