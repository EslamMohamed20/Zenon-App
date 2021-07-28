import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/layout/home_cubit/home_states.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zenon/models/categories_model.dart';
import 'package:zenon/models/products_model.dart';
import 'package:zenon/modules/cart/cubit/cart_cubit.dart';
import 'package:zenon/modules/products/product_details.dart';
import 'package:zenon/shared/components/components.dart';
import 'package:zenon/shared/styles/colors.dart';
import 'package:like_button/like_button.dart';
import 'package:toast/toast.dart' as ToastIndicate ;


class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool favouriteIcon = false;

  // @override
  // void initState() {
  //   HomeCubit.get(context).getcategoriesData();
  //    HomeCubit.get(context).getUserData();    
  //   HomeCubit.get(context).getUserDataFromFirebase();
  //    HomeCubit.get(context).getHomeData();
  //   HomeCubit.get(context).getFavoritesData();
  //   super.initState();
  // }
  

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, state) async {
        if (state is ChangeFavouritesSuccessStates) {
          if (!state.model.stutus) {
            await defaultFlutterToast(
              massege: state.model.message,
              backgroundColor: Colors.red.withOpacity(0.8),
              fontSize: 16,
            );
          }
          await defaultFlutterToast(
            massege: state.model.message,
            backgroundColor: defaultColor.withOpacity(0.8),
            toasttimelenght: Toast.LENGTH_SHORT,
            fontSize: 16,
          );
        }

        if (state is ProductScreenAddToCartSuccessState)
        {
          ToastIndicate.Toast.show('Added to your cart', context , backgroundColor:defaultColor
             , gravity: 0 ,duration: 4 , ); 
        }
          
          if (state is ProductScreenItemInCartState)
        {
          ToastIndicate.Toast.show('This item already in your cart', context , backgroundColor:Colors.red
             , gravity: 0 ,duration: 1 , ); 
        }

        if(state is removeItemFromCartProductScreenState)
        {
           ToastIndicate.Toast.show('Deleted', context , backgroundColor:Colors.red
             , gravity: 0 ,duration: 2 , ); 
        }

      },
      builder: (BuildContext context, state) {
        var cubit = HomeCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeModel != null && cubit.categoriesModel != null && state is! FavoritesGetLoadingdataStates,
          builder: (context) => Container(
              color: Colors.lime[50].withOpacity(0.19),
              child: productsBuilder(
                  cubit.homeModel, cubit.categoriesModel, cubit, context)),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsBuilder(
          HomeModel model, CategoriesModel catModel, cubit, context) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //bunner images
            CarouselSlider.builder(
              options: CarouselOptions(
                height: 200,
                initialPage: 0,
                autoPlay: true,
                viewportFraction: 1.0,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 1000),
                enlargeCenterPage: true,
              ),
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return Image(
                  image: NetworkImage(model.data.banners[index].image),
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
              itemCount: model.data.banners.length,
            ),
            SizedBox(
              height: 6,
            ),
            //category Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                      ),
                      Spacer(),
                    TextButton(onPressed: ()
                   {
                    // Navigator.of(context).pushNamed('/categoriesScreen');
                     Navigator.of(context).pushNamed('/Categouries_navigation_rail',arguments: {0 ,
                      },);
                   },
                   child: Text('Show all' , style: TextStyle (color: Colors.red,),),
                   ),
                   
                    ],
                  ),
                 
                  SizedBox(
                    height: 5,
                  ),
                  // category Slider
                  Container(
                    //  color: Colors.red,
                    height: 140,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (cotext, index) => buildCategryItem(
                            catModel.data.data[index], cubit, context ,index),
                        separatorBuilder: (cotext, index) =>
                            SizedBox(width: 5.0),
                        itemCount: catModel.data.data.length),
                  ),

                  SizedBox(
                    height: 9,
                  ),

                  Text(
                    'New Products',
                    // textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),

            //products in grid view
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: GridView.count(
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                mainAxisSpacing: 4,
                crossAxisSpacing: 2,
                childAspectRatio: 1 / 1.6,
                children: List.generate(
                  model.data.products.length,
                  (index) => buildProductItem(
                      model.data.products[index], context ,index),
                  //
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildCategryItem(Datum catData, cubit, context ,index) =>
   InkWell(
     onTap: ()
     {
      //  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
      //  CategoryFeedsScreen(index: index , catName: catData.name,),
      //  ));
     },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              height: 140,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image(
                image: NetworkImage(catData.image),
                // height: 135,
                // width: 120,
                 // fit: BoxFit.cover,
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.8),
              width: 130,
              height: 25,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                '${catData.name}',
                textAlign: TextAlign.center,
                
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
   );

  Widget buildProductItem(Product model, context , index) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: (){
          Navigator.of(context).
          push(MaterialPageRoute(builder: (context ) => ProductDetails(index: index,)));
          },
         
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //image & dicount
              Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Image(
            image: NetworkImage(model.image),
            // fit: BoxFit.cover ,
            width: double.infinity,
            height: 200,
          ),
          if (model.discount != 0)
            Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.0,
                ),
                margin: EdgeInsets.all(2),
                color: Colors.redAccent[700].withOpacity(0.75),
                child: Text(
                  'Discount',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white),
                ),
            ),
        ],
                ),
              Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
        child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //name
            Text(
              model.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Trajan Pro',
              ),
            ),
            //prices
            Row(
              // mainAxisSize: MainAxisSize.min,
              children: [
                //new price
                Text(
                  '${model.price.round()}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Trajan Pro',
                    height: 1.3,
                    color: defaultColor,
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Text(
                  'L.E',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Trajan Pro',
                    height: 2.05,
                    color: defaultColor,
                    // textBaseline:TextBaseline.alphabetic,
                  ),
                ),
                SizedBox(
                  width: 5.5,
                ),
                //old price
                if (model.discount != 0)
                  Row(
                    children: [
                      Text(
                        '${model.oldPrice.round()}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Trajan Pro',
                          height: 1.3,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        'L.E',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Trajan Pro',
                          height: 1.9,
                          color: Colors.grey,
                          // textBaseline:TextBaseline.alphabetic,
                        ),
                      )
                    ],
                  ),
                Spacer(),
                // IconButton(icon: null, onPressed: () {  },),
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
                  isLiked: HomeCubit.get(context).favourites[model.id],
                  onTap: (val) async {
                    HomeCubit.get(context).changeFavourites(model.id);

                    // favouriteIcon=true ;
                    // print(val);
                    //print(model.id);
                    return !val;
                  },
                ),
              ],
            ),
            Divider(),
            defaultButton(function: ()
            {
               if(CartCubit.get(context).cartItems.containsKey(model.id.toString()))
                      HomeCubit.get(context).productScreencheckItemInCart(model.id.toString() , context);
                     else {
                    CartCubit.get(context).addProductToCart(name: model.name ,
                    price:model.price  , 
                    oldPrice:model.oldPrice??0.0 ,
                    id:model.id.toString() ,
                    image:model.image,
                    discount : model.discount,
                    index: index ,
                    );
                   HomeCubit.get(context).addToCartState();}
                 // CartCubit.get(context).totalAmount();
            },
             text:CartCubit.get(context).cartItems.containsKey(model.id.toString())?'In Cart' :
             'add to cart'  , height: 30 , 
             textStyle: TextStyle(fontWeight: FontWeight.w600 , color: Colors.white, ), 
             background:CartCubit.get(context).cartItems.containsKey(model.id.toString())? Colors.pinkAccent :
              defaultColor),
        
          ],
        ),
              ),
            ],
          ),
      ),
    );
  }
}
