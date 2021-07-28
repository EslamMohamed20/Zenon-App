import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:like_button/like_button.dart';
import 'package:toast/toast.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/modules/cart/cubit/cart_cubit.dart';
import 'package:zenon/modules/cart/cubit/cart_states.dart';
import 'package:zenon/modules/favourites/favourite_product_detail_screen.dart';
import 'package:zenon/modules/products/product_details.dart';
import 'package:zenon/shared/components/components.dart';
import 'package:zenon/shared/styles/colors.dart';

import 'cart_empty.dart';

class CartFullyScreen extends StatefulWidget {
  final int index;

  const CartFullyScreen({this.index});

  @override
  _CartFullyScreenState createState() => _CartFullyScreenState();
}

class _CartFullyScreenState extends State<CartFullyScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cartCubit = CartCubit.get(context);
        print(' cart ${widget.index}');
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FavouriteProductDetailsScreen(
                      id:int.parse( cartCubit.cartItems.values
                          .toList()[widget.index]
                          .id),
                    )));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.189,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(16.0),
                bottomRight: const Radius.circular(16.0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.height * 0.9,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: NetworkImage(
                        '${cartCubit.cartItems.values.toList()[widget.index].image}',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 5.0, left: 5.0, right: 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${cartCubit.cartItems.values.toList()[widget.index].name}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.black),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            //  SizedBox(width: 10,),

                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async
                                { 
                                 await defaultAlertDialog(title: 'Delete' , subTitle: 'Are you sure to delete this item ?' ,
                                  context: context , fun: (){
                                   cartCubit.removeItemFromCart(id: cartCubit.cartItems.values.toList()[widget.index].id);
                                   HomeCubit.get(context).removeItemFromCartProductScreen();
                                  }
                                  );
                                 
                                },
                                borderRadius: BorderRadius.circular(25.0),
                                splashColor: Colors.amberAccent,
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  child: Icon(
                                    Entypo.cross,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Price:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.black),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${cartCubit.cartItems.values.toList()[widget.index].price}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    fontFamily: '',
                                    fontWeight: FontWeight.w500,
                                    color: defaultColor,
                                  ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(
                              width: 2.5,
                            ),
                            Text(
                              'EGP',
                              style:
                                  Theme.of(context).textTheme.caption.copyWith(
                                        fontFamily: '',
                                        fontWeight: FontWeight.w400,
                                        color: defaultColor,
                                        height: 1.5,
                                      ),
                            ),
                            //  SizedBox(width: 10,),

                            SizedBox(
                              width: 5,
                            ),

                            //old price
                            if (cartCubit.cartItems.values
                                    .toList()[widget.index]
                                    .discount !=
                                0)
                              Text(
                                '${cartCubit.cartItems.values.toList()[widget.index].oldPrice}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      fontFamily: '',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 12,
                                    ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            if (cartCubit.cartItems.values
                                    .toList()[widget.index]
                                    .discount !=
                                0)
                              SizedBox(
                                width: 2,
                              ),
                            if (cartCubit.cartItems.values
                                    .toList()[widget.index]
                                    .discount !=
                                0)
                              Text(
                                'EGP',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontFamily: '',
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 8,
                                      color: Colors.grey,
                                      height: 1.5,
                                    ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            //  SizedBox(width: 20,),
                            LikeButton(
                              size: 26,
                              circleColor: CircleColor(
                                start: Color(0xFF2416EE),
                                end: Color(0xFFEB1C1C),
                              ),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: defaultColor,
                                dotSecondaryColor: Colors.blue,
                                dotThirdColor: Color(0xFFFA4C07),
                                dotLastColor: Color(0xFFF52B1D),
                              ),
                              isLiked: false,
                              //HomeCubit.get(context).favourites[model.id] ,
                              onTap: (val) async {
                                //   HomeCubit.get(context).changeFavourites(model.id);
                                // favouriteIcon=true ;
                                // print(val);
                                //print(model.id);
                                return !val;
                              },
                            ),
                            Spacer(),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                   cartCubit.cartItems.values
                                        .toList()[widget.index].quantity<2 ? null :
                                  CartCubit.get(context)
                                      .reduceQuantityOfProductfromCart(
                                    name: cartCubit.cartItems.values
                                        .toList()[widget.index]
                                        .name,
                                    price: cartCubit.cartItems.values
                                        .toList()[widget.index]
                                        .price,
                                    oldPrice: cartCubit.cartItems.values
                                            .toList()[widget.index]
                                            .oldPrice ??
                                        0.0,
                                    id: cartCubit.cartItems.values
                                        .toList()[widget.index]
                                        .id
                                        .toString(),
                                    image: cartCubit.cartItems.values
                                        .toList()[widget.index]
                                        .image,
                                    discount: cartCubit.cartItems.values
                                        .toList()[widget.index]
                                        .discount,
                                    index: cartCubit.cartItems.values
                                        .toList()[widget.index]
                                        .index,
                                  );
                                },
                                borderRadius: BorderRadius.circular(4.0),
                                splashColor: Colors.amberAccent,
                                child: Container(
                                  // height: 40,
                                  // width: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Icon(
                                      Entypo.minus,
                                      color: 
                                      cartCubit.cartItems.values.toList()[widget.index].quantity<2 ?
                                      Colors.grey :Colors.red,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 10,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                width: MediaQuery.of(context).size.width * 0.12,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    defaultColor,
                                    endColor,
                                  ],
                                  stops: [0.0, 0.9],
                                )),
                                child: Text(
                                  '${cartCubit.cartItems.values.toList()[widget.index].quantity}',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color: Colors.white, fontFamily: ''),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  cartCubit.cartItems.values.toList()[widget.index].quantity>=10 ?
                                  Toast.show('It\'s Limited by 10 Items', context ,backgroundColor: Colors.red  ,
                                  duration: 4) :
                                  cartCubit.addProductToCart(
                                    name: cartCubit.cartItems.values
                                        .toList()[widget.index]
                                        .name,
                                    price: cartCubit.cartItems.values
                                        .toList()[widget.index]
                                        .price,
                                    oldPrice: cartCubit.cartItems.values
                                            .toList()[widget.index]
                                            .oldPrice ??
                                        0.0,
                                    id: cartCubit.cartItems.values
                                        .toList()[widget.index]
                                        .id
                                        .toString(),
                                    image: cartCubit.cartItems.values
                                        .toList()[widget.index]
                                        .image,
                                    discount: cartCubit.cartItems.values
                                        .toList()[widget.index]
                                        .discount,
                                    index: cartCubit.cartItems.values
                                        .toList()[widget.index]
                                        .index,
                                  );
                                },
                                borderRadius: BorderRadius.circular(4.0),
                                splashColor: Colors.amberAccent,
                                child: Container(
                                  // height: 40,
                                  // width: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Icon(
                                      Entypo.plus,
                                      color: cartCubit.cartItems.values.toList()[widget.index].quantity>=10 ?Colors.grey :
                                      Colors.green,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
