import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/layout/home_cubit/home_states.dart';
import 'package:zenon/models/categories_model.dart';
import 'package:zenon/shared/styles/colors.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
                  body: ListView.separated(
              itemBuilder: (context, index) =>
                  buildCatItem(cubit.categoriesModel.data.data[index]),
              separatorBuilder: (context, index) => Divider(
                    color: defaultColor.withOpacity(0.6),
                  ),
              itemCount: cubit.categoriesModel.data.data.length),
        );
      },
    );
  }

//cat item in category screen
  Widget buildCatItem(Datum model) {
    return Container(
      color: Colors.white,
      // Colors.lime[50].withOpacity(0.1),
      padding:const EdgeInsets.all(10.0), 
      child: Row(
         mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: NetworkImage(model.image),
            width: 125,
            height: 135,
           // fit: BoxFit.cover,
          ),
          SizedBox(
            width: 10,
          ),
          //title

          Expanded(
            child: Text(
              '${model.name}',
              overflow: TextOverflow.fade,
              softWrap: true,
              //  maxLines: 2,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //Spacer(),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
