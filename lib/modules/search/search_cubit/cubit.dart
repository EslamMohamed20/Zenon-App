



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenon/models/search_model.dart';
import 'package:zenon/modules/search/search_cubit/states.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/shared/network/remote/dio_helper.dart';
import 'package:zenon/shared/network/remote/end_points_urls/end_points.dart';

class SearchCubit extends Cubit<SearchStates>{
SearchCubit():super(SearchInitStates());  //يبدأ بيها

//علشان اقدر اعمل منه اوبجكت اقدر استخدمه ف اى  مكان
static SearchCubit get(context) => BlocProvider.of(context);  // CounterCubit.get(context).توصل لاى حاجه جوه

//هابتدى اعرف متغيراتى بقى والفانكشن اللبتسند قيم فيها

bool searchFieldState =false ;
SearchModel searchModel ;
String changeText ='' ;

void search({
  @required String searchText ,
})
{

emit(SearchLoadingStates());
 DioHelper.postData(
   posturl: SEARCH,
   token: userToken,
    postData:
    {
       'text' :searchText ,
    }
    ).then((value) 
    {
      searchModel=SearchModel.fromJson(value.data);
      print(value.data);
       emit(SearchSuuccessStates(searchModel));
    }
    ).catchError((error){
       print('search error : ${error.toString()}');
      emit(SearchErrorStates(error.tostring));
    });
}

void changeFormFieldState ()
{
  searchFieldState= !searchFieldState;
  emit(ChangeFormFieldState());

}

void  changeFormFieldContent(String text)
{
  changeText = text ;
  emit(ChangeFormFieldContent(changeText));

}


}

