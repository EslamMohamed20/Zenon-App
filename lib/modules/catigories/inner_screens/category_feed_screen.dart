

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:zenon/layout/home_cubit/home_cubit.dart';
// import 'package:zenon/layout/home_cubit/home_states.dart';
// import 'package:zenon/models/search_model.dart';
// import 'package:zenon/shared/styles/colors.dart';

// class CategoryFeedsScreen extends StatelessWidget {
//   final String catName ;
//   final int index;

//   const CategoryFeedsScreen({ this.catName, this.index}) ;


//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<HomeCubit, HomeStates>(
//       listener: (BuildContext context, state)  {},
//       builder: (BuildContext context, state)  {
//         var model = HomeCubit.get(context).findByCategories(catName) ;
//           return  Scaffold(
//                       body : ListView.builder(
//                         itemCount: HomeCubit.get(context).homeModel.data.products.length ,
//                         itemBuilder: (context , index) 
//                         {
//                           return Container(
//         width: 140,
//         height: 150 ,
//         color: Colors.white,
//         padding: EdgeInsets.symmetric(horizontal: 5),
//         child:
        
//          InkWell(
//             onTap: (){
//               Navigator.of(context).pushNamed('/ProductDetailsScreen' ,  arguments: {index});
//               },
             
//                 child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   //image & dicount
//                   Stack(
//             alignment: AlignmentDirectional.bottomStart,
//             children: [
//               Image(
//                 image: NetworkImage(model.image),
//                 // fit: BoxFit.cover ,
//                 width: double.infinity,
//                 height: 150,
//               ),
//               if (model.discount != 0)
//                 Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 5.0,
//                     ),
//                     margin: EdgeInsets.all(2),
//                     color: Colors.redAccent[700].withOpacity(0.75),
//                     child: Text(
//                       'Discount',
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 15,
//                           color: Colors.white),
//                     ),
//                 ),
//             ],
//                     ),
//                   Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
//                child: Column(
//               //   mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //name
//                 Text(
//                   model.name,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     fontFamily: 'Trajan Pro',
//                   ),
//                 ),
//                 //prices
//                 Row(
//                   // mainAxisSize: MainAxisSize.min,
//                   children: [
//                     //new price
//                     Text(
//                       '${model.price.round()}',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Trajan Pro',
//                         height: 1.3,
//                         color: defaultColor,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 1,
//                     ),
//                     Text(
//                       'L.E',
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Trajan Pro',
//                         height: 2.05,
//                         color: defaultColor,
//                         // textBaseline:TextBaseline.alphabetic,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5.5,
//                     ),
//                     //old price
//                     if (model.discount != 0)
//                       Row(
//                         children: [
//                           Text(
//                             '${model.oldPrice.round()}',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               fontFamily: 'Trajan Pro',
//                               height: 1.3,
//                               color: Colors.grey,
//                               decoration: TextDecoration.lineThrough,
//                             ),
//                           ),
//                           Text(
//                             'L.E',
//                             style: TextStyle(
//                               fontSize: 8,
//                               fontWeight: FontWeight.w600,
//                               fontFamily: 'Trajan Pro',
//                               height: 1.9,
//                               color: Colors.grey,
//                               // textBaseline:TextBaseline.alphabetic,
//                             ),
//                           )
//                         ],
//                       ),
//                    // Spacer(),
//                     // IconButton(icon: null, onPressed: () {  },),
//                   //   LikeButton(
//                   //     size: 26,
//                   //     circleColor: CircleColor(
//                   //       start: Color(0xFF2416EE),
//                   //       end: Color(0xFFEB1C1C),
//                   //     ),
//                   //     bubblesColor: BubblesColor(
//                   //       dotPrimaryColor: defaultColor,
//                   //       dotSecondaryColor: Colors.blue,
//                   //       dotThirdColor: Color(0xFFFA4C07),
//                   //       dotLastColor: Color(0xFFF52B1D),
//                   //     ),
//                   //     isLiked: HomeCubit.get(context).favourites[model.id],
//                   //     onTap: (val) async {
//                   //       HomeCubit.get(context).changeFavourites(model.id);

//                   //       // favouriteIcon=true ;
//                   //       // print(val);
//                   //       //print(model.id);
//                   //       return !val;
//                   //     },
//                   //   ),
//                   // 
//                   ],
//                 ),
//               ],
//             ),
//                   ),
                
//                 ],
//               ),
//         ),
//       );
//                         } )
//                       );
    
//       },);
  
//   }
// }