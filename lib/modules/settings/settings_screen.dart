import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:toast/toast.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/layout/home_cubit/home_states.dart';
import 'package:zenon/modules/by_me_user/by_me_cubit/by_me_cubit.dart';
import 'package:zenon/modules/login/login_cubit/login_cubit.dart';
import 'package:zenon/modules/login/login_cubit/login_states.dart';
import 'package:zenon/shared/components/components.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/shared/components/show_image_screen.dart';
import 'package:zenon/shared/styles/colors.dart';

import 'edit_user_info.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  ScrollController _scrollController;
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController newCustomerCardNameController = TextEditingController();
  TextEditingController newCustomerCardPhoneController =
      TextEditingController();
  TextEditingController newCustomerCardIdController = TextEditingController();
  TextEditingController newCustomerCardCashAmountController =
      TextEditingController();
  GlobalKey<FormState> form2Key = GlobalKey<FormState>();
  TextEditingController addNewCardAdminPasswordController =
      TextEditingController();
  TextEditingController addNewCardAdminUserNameController =
      TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var top = 0.0;

  // List<Map<String, String>> admins = [
  //   {'eslam mohamed': '01141752766'},
  //   {'yahia zakaria': '01114220410'},
  // ];

  int i = 0;
  int x = 0;
  bool isAuth = false;
  void checkAdminAuth(Function fun) {
    bool auth = false;
    HomeCubit.get(context).zenonAdmins.forEach((element) {
      if (element.adminName == userNameController.text) {
        if (element.adminPassword == passwordController.text) {
          x = 1;
          // isAuth=true;
          auth = true;
          Navigator.of(context).pop();
          fun();
        }
      }
    });
    !auth
        ? Toast.show(
            'Invailed password or username \n please try again', context,
            backgroundColor: Colors.red, gravity: 1, duration: 2)
        : null;
    // for (i = 0; i < admins.length; i++) {
    //  // admins[i][userNameController.text.toLowerCase()]
    //   if (admins[i][userNameController.text.toLowerCase()]==
    //       passwordController.text) {
    //     x = 1;
    //     // isAuth=true;
    //     Navigator.of(context).pop();
    //     fun();
    //   } else if (i == admins.length - 1 && x == 0)
    //     // isAuth =false;
    //     Toast.show('Invailed password or username \n please try again', context,
    //         backgroundColor: Colors.red, gravity: 1, duration: 3);
    // }
    x = 0;
    passwordController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    HomeCubit.get(context).getcategoriesData();
    HomeCubit.get(context).getUserData();
    HomeCubit.get(context).getUserDataFromFirebase();
    HomeCubit.get(context).getHomeData();
    HomeCubit.get(context).getFavoritesData();
    HomeCubit.get(context).getZenonAdminsFromFirebase();
    HomeCubit.get(context).checkIfUserLogInOrGest();
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  bool isFirebaseStateDone = false;
  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeStates>(listener: (context, state) {
          if (state is GetUserDataFormFirebaseSuccessStates) {
            setState(() {
              isFirebaseStateDone = true;
            });
            print('state :${isFirebaseStateDone}');
          }
          if (state is GetUserDataLoadingStates) {
            setState(() {
              isFirebaseStateDone = false;
            });
            print('state :${isFirebaseStateDone}');
          }
          if (state is CardAllreadyExistOnFireStoreState) {
            Toast.show('This card Already exist in our database', context,
                backgroundColor: Colors.red, duration: 3, gravity: 1);
          }
          if (state is UploadNewZenonCardOnFireStoreSuccessState) {
            Toast.show('Card Added Succefuly', context,
                backgroundColor: Colors.green, duration: 4, gravity: 1);
          }
        }),
        BlocListener<LoginCubit, AppLoginStates>(listener: (context, state) {}),
      ],
      child: ConditionalBuilder(
          condition: isFirebaseStateDone,
          fallback: (context) => Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Getting your data',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
          builder: (context) {
            return Scaffold(
              body: Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        backwardsCompatibility: false,
                        systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor:
                              // cubit.isDark
                              isdarkTheme ? defaultColor : Colors.white,
                          // HexColor('333739') ,
                          statusBarIconBrightness:
                              //cubit.isDark
                              isdarkTheme ? Brightness.light : Brightness.dark,
                        ),
                        automaticallyImplyLeading: false,
                        elevation: 4,
                        expandedHeight: 200,
                        pinned: true,
                        flexibleSpace: LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          top = constraints.biggest.height;
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    starterColor,
                                    endColor,
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: FlexibleSpaceBar(
                              collapseMode: CollapseMode.parallax,
                              centerTitle: true,
                              title: Row(
                                //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AnimatedOpacity(
                                    duration: Duration(milliseconds: 300),
                                    opacity: top <= 110.0 ? 1.0 : 0,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 12,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ShowImage(
                                                NetworkImage(
                                                  cubit.userModlInfo.image ??
                                                      'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg',
                                                ),
                                              );
                                            }));
                                          },
                                          child: Container(
                                            height: kToolbarHeight / 1.8,
                                            width: kToolbarHeight / 1.8,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white,
                                                  blurRadius: 1.0,
                                                ),
                                              ],
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                //fit: BoxFit.fill,
                                                image: NetworkImage(
                                                  cubit.userModlInfo.image ??
                                                      'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          // 'top.toString()',
                                          cubit.userModlInfo.name ?? 'Gest',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              background: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return ShowImage(
                                      NetworkImage(
                                        cubit.userModlInfo.image ??
                                            'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg',
                                      ),
                                    );
                                  }));
                                },
                                child: Image(
                                  image: NetworkImage(cubit
                                          .userModlInfo.image ??
                                      'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //userinfo-------------------------------
                            SizedBox(
                              height: 15,
                            ),
                            titleInfo(context, 'User Information'),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                            buildInfoItem(context,
                                title: 'E-mail',
                                subTitle:
                                    cubit.userModlInfo.email ?? "please login",
                                icon: userTitleIcons[0]),
                            buildInfoItem(context,
                                title: 'Phone number',
                                subTitle: cubit.userModlInfo.phone ??
                                    "please enter ypur phone",
                                icon: userTitleIcons[1]),
                            buildInfoItem(context,
                                title: 'Shipping adress',
                                subTitle:
                                    'Frist adress : ${cubit.userModlInfo.adress_1}\nSecend adress :${cubit.userModlInfo.adress_2} ' ??
                                        "enter your adress",
                                icon: userTitleIcons[2]),
                            buildInfoItem(context,
                                title: 'ZenonCardID',
                                subTitle:cubit.userModlInfo.zenonCardId.length==8?
                                 cubit.userModlInfo.zenonCardId
                                        .replaceRange(0, 5, 'xxxxx') :
                                    cubit.userModlInfo.zenonCardId,
                                icon: userTitleIcons[6]),
                            buildInfoItem(context,
                                title: 'Joined date',
                                subTitle: cubit.userModlInfo.joinedAt ?? "",
                                icon: userTitleIcons[3]),

                            //User Settings
                            titleInfo(context, 'User Settings'),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                            // dark theme
                            ListTileSwitch(
                              value: isdarkTheme,
                              //cubit.isDark,
                              leading: Icon(Ionicons.md_moon),
                              onChanged: (value) {
                               // cubit.themeChange(value);
                              },
                              visualDensity: VisualDensity.comfortable,
                              switchType: SwitchType.cupertino,
                              switchActiveColor: Colors.indigo,
                              title: Text(
                                'Dark Theme',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            //edit user info
                            buildInfoItem(context,
                                title: 'Edit my profile',subTitle: 'if you have an account you able to edit your information',
                                icon: userTitleIcons[7], fun: () {
                              cubit.isSignin?
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditUserInfo())):
                                  Toast.show('Please Login with your Account', context , backgroundColor: Colors.red , duration: 3);

                            }),
                            //login
                            if(!cubit.isSignin)
                            buildInfoItem(context,
                                title: 'Login',
                                subTitle:'Sign In or Sign Up' ,
                                icon: userTitleIcons[9], fun: () {
                                  LoginCubit.get(context)
                                    .logOut(context: context);
                                Navigator.pushReplacementNamed(context, '/loginScreen');
                            }),
                           
                            //log out
                            buildInfoItem(context,
                                title: 'Logout',
                                subTitle:'Logout' ,
                                icon: userTitleIcons[4], fun: () {
                              defaultAlertDialog(
                                context: context,
                                title: 'Sign Out',
                                subTitle: 'Do you wanna Sign Out?!',
                                fun: () => LoginCubit.get(context)
                                    .logOut(context: context),
                              );
                            }),
                            
                            titleInfo(context, 'Admin Settings'),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                            buildInfoItem(context,
                                title: 'Upload new product',
                                subTitle:
                                    'It\'s allowable for zenon admins only',
                                icon: userTitleIcons[5], fun: () {
                              builAlertDialogForAdminAuth(
                                  title: 'New Product',
                                  context: context,
                                  fun: () {
                                    Navigator.of(context)
                                        .pushNamed('/UploadProductFormScreen');
                                  });
                            }),

                            buildInfoItem(context,
                                title: 'Register a new card for a new customer',
                                subTitle:
                                    'It\'s allowable for zenon admins only',
                                icon: userTitleIcons[8], fun: () {
                              builAlertDialogForAddNewCard(
                                  ctx: context, cubit: cubit);
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  _buildFlatActionButtonImage(),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.chat),
              ),
            );
          }),
    );

    // //  BlocConsumer<HomeCubit , HomeStates >(
    // //    listener: (context , state) {} ,
    // //   builder: (context , state) {

    //     return

    // },);
  }

  List<IconData> userTitleIcons = [
    Icons.email,
    Icons.phone,
    Icons.local_shipping,
    Icons.watch_later,
    Icons.logout,
    Icons.headset_mic_outlined,
    Icons.payment,
    Icons.edit,
    Icons.payment,
    Icons.login
  ];

  Widget _buildFlatActionButtonImage() {
    //starting fab position
    final double defaultTopMargin = 200.0 - 4.0;
    //pixels from top where scaling should start
    final double scaleStart = 160.0;
    //pixels from top where scaling should end
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: 16.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          heroTag: "btn1",
          onPressed: () {},
          child: Icon(Icons.camera_alt_outlined),
        ),
      ),
    );
  }

  Widget buildInfoItem(BuildContext context,
      {String title, String subTitle, IconData icon, Function fun }) {
    return ListTile(
      onTap: fun,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
     
      subtitle: Text(
        subTitle ?? '',
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(color: Colors.grey[700]),
      ),
      leading: Icon(icon),
    );
  }

  Widget titleInfo(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.bold, fontSize: 22)),
    );
  }

  builAlertDialogForAdminAuth(
      {@required BuildContext context, String title, Function fun}) {
    showDialog(
        context: context,
        builder: (context) {
          return BlocConsumer<LoginCubit, AppLoginStates>(
              listener: (context, state) {},
              builder: (context, state) {
                return AlertDialog(
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: defaultColor),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  elevation: 6,
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          checkAdminAuth(fun);
                        }
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: defaultColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        passwordController.clear();
                        userNameController.clear();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.red),
                      ),
                    ),
                  ],
                  contentPadding: const EdgeInsets.fromLTRB(24.0, 3, 24.0, 15),
                  content: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'For Zenon admins only!!',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.red),
                        ),
                        Text(
                          'Enter your password & user name',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //user name
                        DefaultFormField(
                            controller: userNameController,
                            keyboardType: TextInputType.name,
                            label: 'User Name',
                            hint: 'eslam mohamed',
                            prefixIcon: Icon(Icons.person),
                            fontSize: 16.5,
                            textWeight: FontWeight.w600,
                            textColor: defaultColor,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please enter a valid user name';
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
                            obscure: LoginCubit.get(context).isPasswordShow,
                            suffixIcon: IconButton(
                              icon: Icon(LoginCubit.get(context).suffixIcon),
                              onPressed: () => LoginCubit.get(context)
                                  .changePasswordVisibility(),
                            ),
                            fontSize: 18,
                            textWeight: FontWeight.w600,
                            textColor: defaultColor,
                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return 'please enter a valid password \npassword must be more than 6 digits';
                              }
                            }),
                      ],
                    ),
                  ),
                );
              });
        });
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
                      'Add a new Zenon card',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (form2Key.currentState.validate()) {
                      bool isAdminAuth = false;
                      //check admin ----------------------------------
                      bool auth = false;
                      HomeCubit.get(context).zenonAdmins.forEach((element) {
                        if (element.adminName == addNewCardAdminUserNameController.text) {
                          if (element.adminPassword ==
                              addNewCardAdminPasswordController.text) {
                            x = 1;
                            // isAuth=true;
                            auth = true;
                          isAdminAuth = true;
                          
                          }
                        }
                      });
                      !auth
                          ? Toast.show(
                              'Invailed password or username \n please try again',
                              context,
                              backgroundColor: Colors.red,
                              gravity: 1,
                              duration: 2)
                          : null;
                      // for (i = 0; i < admins.length; i++) {
                      //   if (admins[i][addNewCardAdminUserNameController.text
                      //           .toLowerCase()] ==
                      //       addNewCardAdminPasswordController.text) {
                      //     x = 1;
                      //     isAuth = true;
                      //     isAdminAuth = true;
                      //   } else if (i == admins.length - 1 && x == 0)
                      //     // isAuth =false;
                      //     Toast.show(
                      //         'Invailed password or username \n please try again',
                      //         context,
                      //         backgroundColor: Colors.red,
                      //         gravity: 1,
                      //         duration: 3);
                      // }
                       x = 0;
                       addNewCardAdminPasswordController.clear();

                      //------------------------------------------------------
                      if (isAdminAuth) {
                        cubit.uploadNewZenonCardOnFireStore(
                            cardId: newCustomerCardIdController.text,
                            cashAmount: double.parse(
                                    newCustomerCardCashAmountController.text ??
                                        '10.0') ??
                                10.0,
                            userName: newCustomerCardNameController.text,
                            userPhone: newCustomerCardPhoneController.text);
                        newCustomerCardIdController.clear();
                        cubit.getAuthsZenonCardsFromFirebase();
                        // Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.green),
                  )),
              TextButton(
                  onPressed: () {
                    newCustomerCardIdController.clear();
                    newCustomerCardCashAmountController.clear();
                    newCustomerCardNameController.clear();
                    newCustomerCardPhoneController.clear();
                    newCustomerCardIdController.clear();
                    addNewCardAdminUserNameController.clear();
                    addNewCardAdminPasswordController.clear();
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
                //customerName
                DefaultFormField(
                    controller: newCustomerCardNameController,
                    keyboardType: TextInputType.name,
                    label: 'Name',
                    hint: 'enter the customer name',
                    prefixIcon: Icon(Icons.person),
                    textColor: defaultColor,
                    fontSize: 15,
                    textWeight: FontWeight.w600,
                    validator: (value) {
                      // if (value.isEmpty || value.contains('/') ||value.contains('*') ||value.contains('#')  ||value.contains('\$')) {
                      //   return 'please enter a valid name';
                      // }
                    }),
                SizedBox(
                  height: 6,
                ),
                //phone
                DefaultFormField(
                    controller: newCustomerCardPhoneController,
                    keyboardType: TextInputType.phone,
                    label: 'Phone',
                    hint: 'Enter coustomer phone',
                    textColor: defaultColor,
                    fontSize: 15,
                    textWeight: FontWeight.w600,
                    prefixIcon: Icon(Icons.phone),
                    //  inputFormatter: FilteringTextInputFormatter.digitsOnly,
                    validator: (value) {
                      // if (value.isEmpty ) {
                      //   return 'please enter your phone';
                      // }
                      // if (value.length != 11 &&  value.length != 8) {
                      //   return 'please enter a valid Phone';
                      // }return null;
                    }),
                //cardId
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DefaultFormField(
                          controller: newCustomerCardIdController,
                          keyboardType: TextInputType.text,
                          label: 'Zenon Card ID',
                          hint: 'Enter the ID',
                          prefixIcon: Icon(Icons.person),
                          textColor: defaultColor,
                          fontSize: 15,
                          textWeight: FontWeight.w600,
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

                //Total Amount
                DefaultFormField(
                    controller: newCustomerCardCashAmountController,
                    keyboardType: TextInputType.number,
                    label: 'Card Charge Amount',
                    hint: 'Enter total cash Amount in card',
                    textColor: defaultColor,
                    fontSize: 15,
                    textWeight: FontWeight.w600,
                    prefixIcon: Icon(Icons.monetization_on_rounded),
                    //  inputFormatter: FilteringTextInputFormatter.digitsOnly,
                    validator: (value) {
                      if (value.isEmpty) {
                        return ' enter "0" if no palance';
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'please enter your valid Amount';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 5,
                ),
                //   Divider(color: Colors.grey[850], height: 6, thickness: 0.7,),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Admin Information ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                //Admin name
                DefaultFormField(
                    controller: addNewCardAdminUserNameController,
                    keyboardType: TextInputType.name,
                    label: 'User Name',
                    hint: 'eslam mohamed',
                    prefixIcon: Icon(Icons.person),
                    fontSize: 16.5,
                    textWeight: FontWeight.w600,
                    textColor: defaultColor,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter a valid user name';
                      }
                    }),
                SizedBox(
                  height: 15,
                ),
                //Password text field
                DefaultFormField(
                    controller: addNewCardAdminPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    label: 'Password',
                    hint: '********',
                    fontSize: 18,
                    textWeight: FontWeight.w600,
                    textColor: defaultColor,
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return 'please enter a valid password \npassword must be more than 6 digits';
                      }
                    }),
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
                  newCustomerCardIdController.clear();
                  newCustomerCardIdController.text =
                      homeCubit.tagInformation.tagId;
                  if (newCustomerCardIdController.text.length == 8)
                    print('done: ${newCustomerCardIdController.text}');
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
