
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:toast/toast.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/layout/home_cubit/home_states.dart';
import 'package:zenon/models/cart_model.dart';
import 'package:zenon/modules/cart/cubit/cart_cubit.dart';
import 'package:zenon/modules/cart/cubit/cart_states.dart';
import 'package:zenon/shared/components/show_image_screen.dart';
import 'package:zenon/shared/styles/colors.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  final int index;
  final int id;

  const ProductDetails({this.index , this.id}) ;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  GlobalKey previewContainer = new GlobalKey();
  bool discriptionBoxFit = false;


  @override
  Widget build(BuildContext context) {
     
// final itemIndex = ModalRoute.of(context).settings.arguments as int ;
   int  itemIndex = widget.index ;
   int itemId = widget.id ;
   
  print('$itemIndex');
   print('$itemId');
  var model = HomeCubit.get(context).homeModel;
  var cartModel = CartCubit.get(context);
 // final productModel = HomeCubit.get(context).findProductById(itemId);
//  int itemIndex = int.parse(routeArgs);
  // print('$itemIndex');
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeStates>(listener: (context , state) {} ,) ,
        BlocListener<CartCubit, CartStates>(listener: (context , state) 
        {
          if(state is AddToCartSuccessState)
          {
            Toast.show('Added to your cart', context , backgroundColor:defaultColor
             , gravity: 0 ,duration: 4 , ); 
          }

          if (state is ItemInCartState) {
            Toast.show('This item already in your cart', context , backgroundColor:Colors.red
             , gravity: 1,duration: 2 , ); 
          }
        }) ,
      ], 
      
      child: BlocConsumer<CartCubit, CartStates>(
        listener: (context , state){},
        builder: (context , state){
          return Scaffold(
            appBar: AppBar(
            //  backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "DETAILS",
                style:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              actions: <Widget>[
              //favour
                Badge(
                  badgeColor: Colors.red,
                  position: BadgePosition.topEnd(top:3 , end:7),
                  animationType: BadgeAnimationType.slide,
                  toAnimate: true,
                  alignment: Alignment.center,
                  elevation: 3,
                  

                badgeContent: Text(HomeCubit.get(context).favouritesModel.data.data.length.toString() , 
                style: TextStyle(color: Colors.white),),
                                child: IconButton(
                    icon: Icon(
                      Icons.favorite_border_outlined,
                    //  color: ColorsConsts.favColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/favouritesScreen');
                    },
                  ),
                ),
                //cart
                Badge(
                   badgeColor:defaultColor,
                  position: BadgePosition.topEnd(top:3 , end:7),
                  animationType: BadgeAnimationType.slide,
                  toAnimate: true,
                  alignment: Alignment.center,
                  elevation: 3,
                  

                badgeContent: Text(CartCubit.get(context).cartItems.length.toString() , 
                style: TextStyle(color: Colors.white),),
                                child: IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                     // color: ColorsConsts.cartColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/cartScreen');
                    },
                  ),
                ),
                //share
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.purple.shade200,
                      onTap: () {},
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.share,
                          size: 23,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  
              ]),
                  
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
                    child: Column(
                children: <Widget>[

                  //item image----------------------
                           Container(
                   foregroundDecoration: BoxDecoration(color: Colors.black12),
                   height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    
                    child: ListView.builder(

                      scrollDirection: Axis.horizontal,
                      itemCount: model.data.products[itemIndex].images.length,
                    
                      itemBuilder: (context , index) {
                        return  InkWell(
                          onTap:(){
                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                            ShowImage(
                              NetworkImage(
                                         
                                         '${model.data.products[itemIndex].images[index]}' 
                                          ,
                                         ),
                        )
                           ));
                        
                          } ,
                          child: 
                           Image.network(
                                         //   itemId == null ?
                                         '${model.data.products[itemIndex].images[index]}' ,
                                         fit: BoxFit.contain,
                                          alignment:Alignment.center ,
                                          loadingBuilder:(context, child, loading){
                                            if (loading == null)
                                          return child;
                             return Center(
                                  child: CircularProgressIndicator(value: loading.expectedTotalBytes != null
                  ? loading.cumulativeBytesLoaded / loading.expectedTotalBytes : null,),);
                                          } ,
                                          ),
                        
                                          
                                        
                     
                     
                        )
                    ; 
                      },
                                    ),
                  
                           
                    ),
                  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),
              //item title-------------------------------------------
              Container(
                //padding: const EdgeInsets.all(16.0),
                color:Colors.white70,
                // Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       //item name
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                            '${model.data.products[itemIndex].name}',
                            maxLines: 2,
                            style: TextStyle(
                              // color: Theme.of(context).textSelectionColor,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w600,
                              fontFamily:  'Trajan Pro',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                       //price----------------------
                     Row(
                       children: [
                               Text(
                    '${model.data.products[itemIndex].price.round()}',
                    style: TextStyle(
                      fontSize: 22,
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
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Trajan Pro',
                      height: 2.05,
                      color: defaultColor,
                      // textBaseline:TextBaseline.alphabetic,
                    ),
                  ),
                  
                   SizedBox(width: 6,),
                  //old price
                  if (model.data.products[itemIndex].discount != 0)
                    Row(
                      children: [
                        Text(
                          '${model.data.products[itemIndex].oldPrice.round()}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Trajan Pro',
                            height: 1.3,
                            color: Colors.red[400],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          'L.E',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Trajan Pro',
                            height: 1.9,
                            color:  Colors.red[400],
                            // textBaseline:TextBaseline.alphabetic,
                          ),
                        )
                      ],
                    ),
                  
                      
                       ],
                     ),
                
                  
                      
                      ],
                    ),
                  ),

                  const SizedBox(height: 3.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                 //discreption 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 5.0),
                    height: !discriptionBoxFit? MediaQuery.of(context).size.height*0.165
                    :null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${model.data.products[itemIndex].description}',
                          overflow: TextOverflow.ellipsis,
                          maxLines:!discriptionBoxFit? 4 :model.data.products[itemIndex].description.codeUnits.length  ,
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            height: 1.1,
                            
                          ),
                        ),
                       //read more
                        TextButton(
              
                          onPressed: ()
                        {
                          setState(() {
                            discriptionBoxFit=! discriptionBoxFit;
                          });
                        }, 
                        child: Text(!discriptionBoxFit?'read more...' :'read less'
                        , style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,),))
                      ],
                    ),
                  ),
                //  const SizedBox(height: 5.0),
             
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //   child: Divider(
                  //     thickness: 1,
                  //     color: Colors.grey,
                  //     height: 1,
                  //   ),
                  // ),
                  // _details( 'Brand: ', 'BrandName'),
                  // _details( 'Quantity: ', '12 Left'),
                  // _details('Category: ', 'Cat Name'),
                  // _details( 'Popularity: ', 'Popular'),
                  // SizedBox(
                  //   height: 15,
                  // ),
                   Divider(
                    thickness: 1,
                    color: Colors.grey,
                    height: 1,
                  ),

                  // const SizedBox(height: 15.0),
                  Container(
                    color: Theme.of(context).backgroundColor,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'No reviews yet',
                            style: TextStyle(
                                color: Theme.of(context).textSelectionColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 21.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            'Be the first review!',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20.0,
                              // color: themeState.darkTheme
                              //     ? Theme.of(context).disabledColor
                              //     : ColorsConsts.subTitle,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                  ],
                ),
              ),
              // const SizedBox(height: 15.0),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Text(
                  'Suggested products:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                padding:EdgeInsets.only(bottom: 10), 
                width: MediaQuery.of(context).size.width *1,
                height: 200,
                child: ListView.separated(
                  itemCount: 7,
                 // shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext ctx, int index_1) {
                  return buildProductItem(model.data.products[index_1] , context ,index_1);
                  },
                  separatorBuilder:(BuildContext ctx, int index)=> Container( width: 7,
                  child: Divider( 
                  color:Theme.of(context).scaffoldBackgroundColor
                  ),
                  ) ,
                ),
              ),
            ],
                  ),
                  
                 ],
              ),
          ),
          
          bottomSheet:  Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 50,
                child: RaisedButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(side: BorderSide.none),
                  color: Colors.redAccent.shade400,
                  onPressed: ()async {
                    if(cartModel.cartItems.containsKey(model.data.products[itemIndex].id.toString()))
                     {
                      cartModel.checkItemInCart(model.data.products[itemIndex].id.toString());}
                     else {
                    cartModel.addProductToCart(name: model.data.products[itemIndex].name ,
                    price:model.data.products[itemIndex].price  , 
                    oldPrice:model.data.products[itemIndex].oldPrice??0.0 ,
                    id:model.data.products[itemIndex].id.toString() ,
                    image:model.data.products[itemIndex].image,
                    discount : model.data.products[itemIndex].discount,
                    index: widget.index ,
                    );
                    HomeCubit.get(context).addToCartState();
                     }
                   
                  },
                  child: Text(
                    cartModel.cartItems.containsKey(model.data.products[itemIndex].id.toString())?'In Cart'.toUpperCase():
                    'Add to Cart'.toUpperCase(),
                    style: TextStyle(fontSize: 16, color: Colors.white , fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 50,
                child: RaisedButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(side: BorderSide.none),
                  color: Theme.of(context).backgroundColor,
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        'Buy now'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textSelectionColor , fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.payment,
                        color: Colors.green.shade700,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child:  Container(
                color: Colors.grey.shade800,
                height:50 ,
                child: LikeButton(
                  
                    size: 35,
                    circleColor: CircleColor(
                      start: Color(0xFF2416EE),
                      end: Color(0xFFEB0D0D),
                    ),
                    
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: defaultColor,
                      dotSecondaryColor: Colors.blue,
                      dotThirdColor: Color(0xFFFA4C07),
                      dotLastColor: Color(0xFFEE2011),
                    ),
                    isLiked: HomeCubit.get(context).favourites[model.data.products[itemIndex].id],
                    onTap: (val) async {
                      HomeCubit.get(context).changeFavourites(model.data.products[itemIndex].id);

                      // favouriteIcon=true ;
                      // print(val);
                      //print(model.id);
                      return !val;
                    },
                  ),
              ),
            ),
          ])
                 ,
     
     
        );
    
        } ,
                )
   
     ) ;
    // BlocConsumer<HomeCubit, HomeStates>(
    //   // listener: (BuildContext context, state)  {},
    //   // builder: (BuildContext context, state)  {
       
        // return   },

        //  );
  }

  Widget _details( String title, String info) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
      child: Row(
      //  mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontWeight: FontWeight.w600,
                fontSize: 21.0),
          ),
          Text(
            info,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20.0,
              // color: themeState
              //     ? Theme.of(context).disabledColor
              //     : ColorsConsts.subTitle,
            ),
          ),
        ],
      ),
    );
  }
   Widget buildProductItem( model, context ,index) {
    return Container(
      width: 140,
      height: 150 ,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context ) => ProductDetails(index: index,)));
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
            height: 150,
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
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
           child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //name
            Text(
              model.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
                    fontWeight: FontWeight.w500,
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
               // Spacer(),
                // IconButton(icon: null, onPressed: () {  },),
              //   LikeButton(
              //     size: 26,
              //     circleColor: CircleColor(
              //       start: Color(0xFF2416EE),
              //       end: Color(0xFFEB1C1C),
              //     ),
              //     bubblesColor: BubblesColor(
              //       dotPrimaryColor: defaultColor,
              //       dotSecondaryColor: Colors.blue,
              //       dotThirdColor: Color(0xFFFA4C07),
              //       dotLastColor: Color(0xFFF52B1D),
              //     ),
              //     isLiked: HomeCubit.get(context).favourites[model.id],
              //     onTap: (val) async {
              //       HomeCubit.get(context).changeFavourites(model.id);

              //       // favouriteIcon=true ;
              //       // print(val);
              //       //print(model.id);
              //       return !val;
              //     },
              //   ),
              // 
              ],
            ),
          ],
        ),
              ),
            
            ],
          ),
      ),
    );
  }

}
