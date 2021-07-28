import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/layout/home_cubit/home_states.dart';
import 'package:zenon/models/favoritites_model.dart';
import 'package:zenon/modules/cart/cubit/cart_cubit.dart';
import 'package:zenon/shared/components/components.dart';
import 'package:zenon/shared/styles/colors.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, state)async { 
        if(state is ChangeFavouritesSuccessStates)  {
          if (!state.model.stutus) 
          {
            await defaultFlutterToast(
              massege: state.model.message, 
              backgroundColor: Colors.red.withOpacity(0.8),
              fontSize: 16,);
          } await defaultFlutterToast(
              massege: state.model.message, 
              backgroundColor: defaultColor.withOpacity(0.8),
              toasttimelenght:Toast.LENGTH_SHORT,
              
              fontSize: 16,);
        }
      },
      builder: (BuildContext context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
                  body: ConditionalBuilder(
                    condition: state is !FavoritesGetLoadingdataStates,
                    builder: (BuildContext context) { 
                      return ListView.separated(
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) => Divider(
                      color: defaultColor.withOpacity(0.6),
                    ),
                itemCount: cubit.favouritesModel.data.data.length , 
                 itemBuilder: (context, index) =>buildListViewItem(cubit.favouritesModel.data.data[index].product ,
                 context , cubit.favouritesModel.data.data[index].product.id ,),);
                     },
                    fallback:(BuildContext context)=> Center(child: CircularProgressIndicator(),), 
                      ),
        );
      },
    );
    }

  Widget buildFavouriteItem(Data favmodel , context , index)
  {
    return Container(
      color: Colors.lime[50].withOpacity(0.1),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      height: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(
                    favmodel.data[index].product.image),
              //  fit: BoxFit.cover,
                width: 148,
                height: 160,
              ),
              //discount
              if (favmodel.data[index].product.discount != 0)
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
          SizedBox(
            width: 6,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //name
                Text(
                  favmodel.data[index].product.name,
                  // maxLines: 2,
                  //  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Trajan Pro',
                  ),
                ),
                Spacer(),
                //prices
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    //new price
                    Text(
                      '${favmodel.data[index].product.price}',
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
                       
                      ),
                    ),
                    SizedBox(
                      width: 5.5,
                    ),
                    //old price
                    if (favmodel.data[index].product.discount != 0)
                      Row(
                        children: [
                          Text(
                            '${favmodel.data[index].product.oldPrice}',
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
                      isLiked:HomeCubit.get(context).favourites[favmodel.data[index].product.id],
                      onTap: (val) async {
                      HomeCubit.get(context).changeFavourites(favmodel.data[index].product.id);
                        return !val;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  
  }



}
