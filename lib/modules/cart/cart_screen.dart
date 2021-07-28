
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/modules/cart/cubit/cart_cubit.dart';
import 'package:zenon/modules/cart/cubit/cart_states.dart';
import 'package:zenon/shared/components/components.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/shared/styles/colors.dart';

import 'cart_empty.dart';
import 'cart_fully.dart';

class CartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit , CartStates>(
      listener: (context , state) {} ,
      builder: (context , state) {
         var cartCubit = CartCubit.get(context);
      
        return  cartCubit.cartItems.isEmpty?Scaffold(
      appBar: AppBar(
        backgroundColor:  defaultColor,
        title: Text('Your Cart'),
        centerTitle: true,
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle.copyWith(color: Colors.white ,
            shadows:[
              Shadow(color: Colors.redAccent , blurRadius: 5 , offset: Offset(0.2 , 0.7)),
            ] ),
      ),
      body: CartEmptyScreen()  ,
    ) :
    Scaffold(
      appBar: AppBar(
        backgroundColor:  defaultColor,
        title: Text('Your Cart'),
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
                                   cartCubit.removeAllItemFromCart();
                                  HomeCubit.get(context).removeItemFromCartProductScreen();
                                  }
                                  );
              
            },
            icon: Icon(Feather.trash),
          ),
        ],
      ),
      bottomSheet: checkoutSection(context  ,cartCubit ),
      
      body: Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: ListView.separated(
             itemCount: cartCubit.cartItems.length ,
            itemBuilder: (BuildContext context , index) { return  CartFullyScreen(index: index,) ;},
          separatorBuilder:  (BuildContext context , index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(height: 0, color: defaultColor,)),),
      )


    );

      //CartEmptyScreen();
      }, );
    
  
  }

   Widget checkoutSection (BuildContext context , CartCubit cartCubit ) {
    return Container(

      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top:  BorderSide(color: Colors.grey , width: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Row (
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Material(
                color: defaultColor,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Colors.redAccent),
                ),
                child: InkWell(
                  onTap: (){},
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
            Spacer(),
            Text('Total:' ,
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20)
            ),
            SizedBox(width: 2.5,),
            Text('${cartCubit.total.toStringAsFixed(2)}' ,

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
   }

}