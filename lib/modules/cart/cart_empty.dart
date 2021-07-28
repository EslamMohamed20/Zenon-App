import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zenon/shared/components/components.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/shared/styles/colors.dart';

class CartEmptyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //color: Theme.of(context).scaffoldBackgroundColor,
    return Scaffold(

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/emptyCart.png'),
              )),
            ),
          ),
          Text(
            'Your Cart Is Empty!!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Looks Like You didn\'t\n add anything to your cart yet!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 20,
                  color: isdarkTheme ? Colors.white70 : Colors.grey[600],
                ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.05,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/HomePage');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: defaultColor),
                ),
              ),
              icon: Icon(
                Entypo.home,
                color: defaultColor,
              ),
              label: Text(
                'SHOP NOW',
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
    );
  }
}
