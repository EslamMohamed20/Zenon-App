
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenon/modules/search/search_cubit/states.dart';
import 'package:zenon/shared/components/components.dart';
import 'package:zenon/shared/styles/colors.dart';

import 'search_cubit/cubit.dart';

class SearchScreen extends StatelessWidget {
    TextEditingController searchController = TextEditingController () ;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)  => SearchCubit(),
      child: BlocConsumer<SearchCubit , SearchStates>(
        listener: (context , state) {
          
        } ,
        builder: (context , state) {
          var cubit = SearchCubit.get(context);
          return  
           Scaffold(
      appBar: AppBar(
      
        title: Form(
               key: formKey ,
                  child: SizedBox(
            height: 30,
            child: DefaultFormField(
              textAlignVertical: TextAlignVertical.center,
              contentPadding:  EdgeInsets.symmetric(horizontal: 9 ,vertical: 0),
             controller: searchController, 
             textInputAction: TextInputAction.search,
             keyboardType: TextInputType.text,
             hint: 'What are you looking for?...', 
             errorheight: 0,
               hintStyle: TextStyle(color: Colors.indigo[300] ,fontWeight: FontWeight.w400 ),
               validator: (value)
               {
                 if(value.isEmpty) 
                   return 'not valid';
                 
               },
                 
               fontSize:16 ,
               textColor:Colors.black ,
              //   suffixIcon:Icons.search, 
               textWeight:FontWeight.w600 ,
               borderRadius: BorderRadius.circular(10),
               onTap: (){
                cubit.changeFormFieldState();
               },
                 onChanged: (textval){
                      cubit.search(searchText: textval) ;
                      
                 },
               onSubmit: (text){
                   if(formKey.currentState.validate())
                 {
                   cubit.changeFormFieldState();
                   cubit.search(searchText: text) ;
                 }
                  else 
                    defaultFlutterToast( massege: 'Type anything to search',fontSize: 15, backgroundColor:Colors.red  ,);
                 
               }

           ),
              
               ),
          ),
        actions: [
        if(!cubit.searchFieldState)
           IconButton(icon: Icon(Icons.search),onPressed:(){
             if(formKey.currentState.validate())
                 cubit.search(searchText: searchController.text) ;
             else
                defaultFlutterToast(massege: 'Type anything to search',fontSize: 15,backgroundColor:Colors.red  ,);
           cubit.changeFormFieldState();
           })
        else IconButton(icon: Icon(Icons.cancel),onPressed:(){
          cubit.changeFormFieldState();
          searchController.clear();
        }),
        
            
        ],

      ),
      body:
       Column(
         //   mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
      SizedBox(height:6 ,),
     if(state is SearchLoadingStates)
     LinearProgressIndicator(),

      SizedBox(height:6),
      
      if(state is SearchSuuccessStates)
      Expanded(
        child: ListView.separated(
          itemCount: cubit.searchModel.data.data.length ,
          itemBuilder: (context , index) =>buildListViewItem(cubit.searchModel.data.data[index], context ,
          index  ,  isOldPrice:false) , 
          separatorBuilder:(context , index)=> Divider(
                    color: defaultColor.withOpacity(0.6), 

          ),
          ),
      
      ),],
          )
    );
 
        }, 
        
        ),
      );
    
    
    }
}