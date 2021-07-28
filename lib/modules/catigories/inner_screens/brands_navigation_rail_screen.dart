
//الشريط الل ف الجنب
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/layout/home_cubit/home_states.dart';
import 'package:zenon/shared/styles/colors.dart';

import 'brands_rail_widget.dart';

class CategouriesNavigationRailScreen extends StatefulWidget {
  CategouriesNavigationRailScreen({Key key}) : super(key: key);

  static const routeName = '/Categouries_navigation_rail';
  @override
  _CategouriesNavigationRailScreenState createState() =>
      _CategouriesNavigationRailScreenState();
}

class _CategouriesNavigationRailScreenState
    extends State<CategouriesNavigationRailScreen> {
  int _selectedIndex = 0;
  final padding = 8.0;
  String routeArgs;
  String brand;

  get categoriesModelConst => null;
  @override
  void didChangeDependencies() {
    routeArgs = ModalRoute.of(context).settings.arguments.toString();
    print(routeArgs.toString());
    _selectedIndex = int.parse(
      routeArgs.substring(1, 2),
    );
    // print(routeArgs.toString());
    if (_selectedIndex == 7) {
      setState(() {
        brand = 'Electronics';
      });
    }
    if (_selectedIndex == 6) {
      setState(() {
        brand = 'Appliances';
      });
    }
    if (_selectedIndex == 5) {
      setState(() {
        brand = 'Computers';
      });
    }
    if (_selectedIndex == 4) {
      setState(() {
        brand = 'Toys';
      });
    }
    if (_selectedIndex == 3) {
      setState(() {
        brand = 'Sports';
      });
    }
    if (_selectedIndex == 2) {
      setState(() {
        brand = 'Kitchen';
      });
    }
    if (_selectedIndex == 1) {
      setState(() {
        brand = 'Mobiles';
      });
    }
    if (_selectedIndex == 0) {
      setState(() {
        brand = 'All';
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var catCubit = HomeCubit.get(context).categoriesModel;
         length = catCubit.data.data.length;
        return Scaffold(
          appBar: AppBar(title: Text('All Categories'),),
          body: Row(
            children: <Widget>[
              LayoutBuilder(
                builder: (context, constraint) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: NavigationRail(
                          minWidth: 56.0,
                          groupAlignment: 1.0,
                          selectedIndex: _selectedIndex,
                          onDestinationSelected: (int index) {
                            setState(() {
                              _selectedIndex = index;
                              if (_selectedIndex == 7) {
                                setState(() {
                                  brand = 'Electronics';
                                });
                              }
                              if (_selectedIndex == 6) {
                                setState(() {
                                  brand = 'Appliances';
                                });
                              }
                              if (_selectedIndex == 5) {
                                setState(() {
                                  brand = 'Computers';
                                });
                              }
                              if (_selectedIndex == 4) {
                                setState(() {
                                  brand = 'Toys';
                                });
                              }
                              if (_selectedIndex == 3) {
                                setState(() {
                                  brand = 'Sports';
                                });
                              }
                              if (_selectedIndex == 2) {
                                setState(() {
                                  brand = 'Kitchen';
                                });
                              }
                              if (_selectedIndex == 1) {
                                setState(() {
                                  brand = 'Mobiles';
                                });
                              }
                              if (_selectedIndex == 0) {
                                setState(() {
                                  brand = 'All';
                                });
                              }
                              print(brand);
                            });
                          },
                          labelType: NavigationRailLabelType.all,
                          leading: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                      "https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg"),
                                ),
                              ),
                              SizedBox(
                                height: 80,
                              ),
                            ],
                          ),
                          selectedLabelTextStyle: TextStyle(
                            color: defaultColor ,
                            //Color(0xffffe6bc97),
                            fontSize: 20,
                            letterSpacing: 1,
                            decoration: TextDecoration.none,
                            decorationThickness: 2.5,
                          ),
                          unselectedLabelTextStyle: TextStyle(
                            fontSize: 15,
                            letterSpacing: 0.8,
                          ),
                          destinations: [
                            buildRotatedTextRailDestination("All", padding),
                            buildRotatedTextRailDestination('Computers', padding),
                            buildRotatedTextRailDestination("Mobiles", padding),
                            buildRotatedTextRailDestination("Sports", padding),
                            buildRotatedTextRailDestination("Toys", padding),
                            buildRotatedTextRailDestination("Kitchen", padding),
                            buildRotatedTextRailDestination("Electronics", padding),
                            buildRotatedTextRailDestination("Appliances", padding),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              // This is the main content.

              ContentSpace(context, brand)
            ],
          ),
        );
      },
    );
  }
}

NavigationRailDestination buildRotatedTextRailDestination(
    String text, double padding) {
  return NavigationRailDestination(
    icon: SizedBox.shrink(),
    label: Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: RotatedBox(
        quarterTurns: -1,
        child: Text(text),
      ),
    ),
  );
}

 int length;
class ContentSpace extends StatelessWidget {
  // final int _selectedIndex;

  final String brand;
  ContentSpace(BuildContext context, this.brand);
 
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView.builder(
            itemCount: length,
            itemBuilder: (BuildContext context, int index) =>
                CategouriesNavigationRail(catIndex:index ,),
          ),
        ),
      ),
    );
  }
}
