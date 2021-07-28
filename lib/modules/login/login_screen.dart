import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:toast/toast.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/modules/sign_up/sign_up_screen.dart';
import 'package:zenon/shared/components/components.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/shared/network/local/cacheHelper.dart';
import 'package:zenon/shared/styles/colors.dart';
import 'login_cubit/login_cubit.dart';
import 'login_cubit/login_states.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, AppLoginStates>(
        listener: (BuildContext context, state) {
          //state is UserLoginWithFirebaseEmailSuccesstState
          ////AppLoginSuccesstState
          //FetchDataAfterLoginSuccessState
          if (state is AppLoginSuccesstState) {
            Toast.show(
              'Welcome Back',
              context,
              duration: 3,
              backgroundColor: defaultColor.withOpacity(0.9),
            );
            setState(() {
              userToken = CacheHelper.getData(key: 'token');
            });
            HomeCubit.get(context).getcategoriesData();
            HomeCubit.get(context).getUserData();
            HomeCubit.get(context).getUserDataFromFirebase();
            HomeCubit.get(context).getHomeData();
            HomeCubit.get(context).getFavoritesData();
            Navigator.of(context).pushReplacementNamed('/HomePage');
          }
          if (state is UserLoginWithFirebaseEmailErrorState) {
            print('screen :${state.error.message}');
            Toast.show(
              '${state.error.message}',
              context,
              duration: 3,
              backgroundColor: Colors.red.withOpacity(0.9),
            );
          }

          if (state is GetGestInfoFromFirebaseErrorState) {
            Toast.show('please signin with your email or signUp', context,
                backgroundColor: Colors.red, duration: 2);
          }

          // if(state is UserLoginWithFirebaseGoogleSuccesstState)
          // {
          //   Toast.show(
          //    'Welcome Back',
          //    context ,
          //    duration: 3,
          //     backgroundColor:defaultColor.withOpacity(0.9),);
          //     setState(() {
          //       userToken = CacheHelper.getData(key: 'token');
          //     });
          //      HomeCubit.get(context).getcategoriesData();
          //     HomeCubit.get(context).getUserData();
          //     HomeCubit.get(context).getHomeData();
          //     HomeCubit.get(context).getFavoritesData();
          //      Navigator.of(context).pushReplacementNamed('/HomePage');
          // }
          if (state is UserLoginWithFirebaseGoogleErrorState) {
            print('screen :${state.error.message}');
            Toast.show(
              '${state.error.message}',
              context,
              duration: 3,
              backgroundColor: Colors.red.withOpacity(0.9),
            );
          }
        },
        builder: (BuildContext context, state) {
          var cubit = LoginCubit.get(context);
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
                        Container(
                          padding: EdgeInsets.only(bottom: 7),
                          alignment: Alignment.topCenter,
                          height: MediaQuery.of(context).size.width * 0.605,
                          //  width: MediaQuery.of(context).size.width *0.6,
                          child: Image.asset('assets/images/zenonLogo.png'),
                        ),
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                        ),
                        Text(
                          'Login now to our application store',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.grey[500],
                              ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        //email text field
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
                            prefixIcon: Icon(Icons.lock_outline),
                            obscure: cubit.isPasswordShow,
                            suffixIcon: IconButton(
                              icon: Icon(cubit.suffixIcon),
                              onPressed: () => cubit.changePasswordVisibility(),
                            ),
                            fontSize: 18,
                            textWeight: FontWeight.w600,
                            textColor: defaultColor,
                            onSubmit: (_) {
                              if (formKey.currentState.validate()) {
                                // cubit.UserLogin(
                                //     email: emailController.text,
                                //     password: passwordController.text ,
                                //     context: context);
                                cubit.userLoginWithFirebaseEmail(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    context: context);
                              } else
                                null;
                            },
                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return 'please enter a valid password \npassword must be more than 6 digits';
                              }
                            }),
                        SizedBox(
                          height: 25,
                        ),
                        //login button
                        ConditionalBuilder(
                          condition: state
                                  is! UserLoginWithFirebaseEmailLoadingState &&
                              state is! GetGestInfoFromFirebaseLoadingState &&
                              state is! AppLoginLoadingState &&
                              state is! FetchDataAfterLoginLoadingState, //الشرط
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState.validate()) {
                                // cubit.UserLogin(
                                //     email: emailController.text,
                                //     password: passwordController.text,
                                //     context: context);
                                cubit.userLoginWithFirebaseEmail(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    context: context);
                              } else
                                null;
                            },
                            text: 'login',
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w700),
                            isUpperCase: true,
                            background: defaultColor,
                          ),
                          // لو الشرط صح يعمل ايه
                          fallback: (context) => Center(
                              child:
                                  CircularProgressIndicator()), // لو الشرط غلط ماذا يفعل
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don\'t have an account?",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: 15,
                                  ),
                            ),
                            defaultTextButton(
                              onpressed: () {
                                Navigator.of(context)
                                    .pushNamed('/signUpScreen');
                              },
                              text: 'Sign up',
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        //or login with 'google , facebook , without login'
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Divider(
                                  thickness: 2,
                                  color: defaultColor,
                                ),
                              ),
                            ),
                            Text(
                              'Or login with',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child:
                                    Divider(thickness: 2, color: defaultColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlineButton.icon(
                              onPressed: () {
                                //  cubit.userLoginWithFirebaseFacebook();
                                Toast.show('Not supported now', context,
                                    backgroundColor: Colors.red, duration: 2);
                              },
                              icon: Icon(
                                Feather.facebook,
                                color: defaultColor,
                              ),
                              label: Text(
                                'Facebook',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              shape: StadiumBorder(),
                              highlightColor: defaultColor.withOpacity(0.32),
                              borderSide: BorderSide(
                                width: 2,
                                color: defaultColor,
                              ),
                            ),
                            //   SizedBox(
                            //   width: 10,
                            // ),
                            OutlineButton.icon(
                              onPressed: () {
                                cubit.userLoginWithFirebaseGoogle(
                                    context: context);
                              },
                              icon: Icon(
                                Entypo.google_,
                                color: Colors.redAccent[700],
                              ),
                              label: Text(
                                'Google',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              shape: StadiumBorder(),
                              highlightColor:
                                  Colors.red.shade200.withOpacity(0.34),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        //as aguest
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlineButton(
                              onPressed: () async {
                                await cubit
                                    .getGestInfoFromFirebase()
                                    .then((value) {
                                  cubit.userLoginWithFirebaseEmail(
                                      email: LoginCubit.get(context)
                                          .gestInfo
                                          .email,
                                      //'zenoncomgest@zenon.com',
                                      // LoginCubit.get(context).loginModel.data.email,
                                      password: LoginCubit.get(context)
                                          .gestInfo
                                          .password,
                                      // '01141752766',
                                      //LoginCubit.get(context).loginModel.data.email,
                                      context: context,
                                      istoken: false);
                                });
                              },
                              child: Text(
                                'Sign in as a guest',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              shape: StadiumBorder(),
                              highlightColor: defaultColor.withOpacity(0.32),
                              borderSide: BorderSide(
                                width: 2,
                                color: defaultColor,
                              ),
                            ),
                          ],
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
