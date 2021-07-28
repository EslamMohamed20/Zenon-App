

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zenon/shared/styles/colors.dart';

import 'by_me_cubit/by_me_cubit.dart';
import 'by_me_cubit/by_me_stetes.dart';

class MarketCustomerBill extends StatefulWidget {
  @override
  _MarketCustomerBillState createState() => _MarketCustomerBillState();
}

class _MarketCustomerBillState extends State<MarketCustomerBill> {
      GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState()  {
    ByMeCubit.get(context).realtimeProducts.values.toList().clear();
    ByMeCubit.get(context).billTotalAmount=0;
    ByMeCubit.get(context).currentCardAmount=0;
      ByMeCubit.get(context).getOrderBillFromRealTimeDatabase();
      super.initState();
  }
  Future<void> onRefreshMethod()async
{
 await  ByMeCubit.get(context).getOrderBillFromRealTimeDatabase();
}
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ByMeCubit , ByMeCubitStates>(
        listener: (context , state){
        },
        builder: (context ,state){
    var byMeCubit = ByMeCubit.get(context);
    return byMeCubit.realtimeProductsList.isNotEmpty? Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body:ConditionalBuilder(condition: state is! GetOrderBillFromRealTimeDatabasLoadingState,
        fallback: (context)=> Center(child: CircularProgressIndicator(),),
         builder: (context){
           return   RefreshIndicator(
             onRefresh: ()=> onRefreshMethod(),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            child: Card(
          elevation: 6,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)) ,
          margin:const EdgeInsets.symmetric(horizontal: 18 , vertical: 12,), 
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18 , vertical: 15,), 
          child: Column (
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   
                    
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
               Image(image: AssetImage('assets/images/zenonLogo4.png'), height:150 , width: 150,),
                     ],
                   ),
                   SizedBox(height: 10,),
                    Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Text('Date : ' ,
               overflow : TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w500 , 
               fontSize: 15.5 , fontFamily: '', color: Colors.grey[600],),),
            Text('${DateFormat.yMMMd().format(DateTime.now())}' ,
               style: TextStyle(fontWeight: FontWeight.w500 ,  fontFamily: '',
               fontSize: 15.5, color: Colors.grey[600],), ),
                    ],),
                    SizedBox(height: 2,),
                    Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Text('Time : ' ,
               overflow : TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w500 , 
               fontSize: 15.5 , fontFamily: '', color: Colors.grey[600],),),
            Text('${DateFormat.Hms().format(DateTime.now())}' ,
               style: TextStyle(fontWeight: FontWeight.w500 ,  fontFamily: '',
               fontSize: 15.5, color: Colors.grey[600],), ),
                    ],),
                   SizedBox(height: 5,),
                    Row(children: [
            Expanded(
        child: Text('Product Name' , style: TextStyle(color: defaultColor,fontSize: 17,
         fontWeight: FontWeight.w600),
        ),
            ),
            Text('Price' , style: TextStyle(color: defaultColor,fontSize: 17,
         fontWeight: FontWeight.w600),),

                    ],),
                    SizedBox(height: 10,),
                    ListView.separated(
            itemCount: byMeCubit.realtimeProductsList.length,
            shrinkWrap: true,
                physics:BouncingScrollPhysics(),
            itemBuilder: (context , index){
        return byMeCubit.realtimeProductsList[index]==''?SizedBox(height: 0,width: 0,): Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Expanded(
        child: 
         Text(
        //  byMeCubit.realtimeProductsList[index]==''?'':
            '${byMeCubit.realtimeProductsList[index].toString().split(' ')[0].trim()}' ,
         overflow : TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.w500 , 
         fontSize: 15.5 , fontFamily: '', ),),
            ),
            //price----
            Text(
             // byMeCubit.realtimeProductsList[index]==''?'':
        '${byMeCubit.realtimeProductsList[index].toString().split(' ')[1].split('L')[0].trim()} L.E'
         , style: TextStyle(fontWeight: FontWeight.w500 ,  fontFamily: '',
               fontSize: 15.5),),
                    ],);
            },
               separatorBuilder: (context , index){
         return byMeCubit.realtimeProductsList[index]==''?SizedBox(height: 0,width: 0,):Divider();
               }, )
                    ,
                    Divider(thickness: 1.5,),
                    Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Expanded(
            child: Text('Total bill amount : ' ,
            
         overflow : TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.w600 ,color: defaultColor, 
         fontSize: 17 , fontFamily: '', ),),
            ),
            Text('${byMeCubit.billTotalAmount??0} L.E' , style: TextStyle(fontWeight: FontWeight.w600 ,  fontFamily: '',
            fontSize: 17 , color: defaultColor,),),
                    ],)
                , 
                     Divider(thickness: 1.5, height: 20,),
                    Text('Customer Information' ,
                     style: TextStyle(color: defaultColor,fontSize: 17,
         fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8,),
                   Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Text('Deduction amount from your card : ' ,
               overflow : TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w500 , 
               fontSize: 15.5 , fontFamily: '', ),),
            Expanded(
         child: Text('${byMeCubit.billTotalAmount??0} L.E' , style: TextStyle(fontWeight: FontWeight.w500 ,  fontFamily: '',
         fontSize: 15.5),),
            ),
                    ],),
                    SizedBox(height: 5,),
                   
                Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Text('The Total Amount in your card : ' ,
               overflow : TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w500 , 
               fontSize: 15.5 , fontFamily: '', ),),
            Expanded(
         child: Text('${byMeCubit.currentCardAmount??0.0} L.E' , style: TextStyle(fontWeight: FontWeight.w500 ,  fontFamily: '',
         fontSize: 15.5),),
            ),
                    ],)
                ,
                SizedBox(height: 12,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
               Text('Thank You  For Trusting Zenon Market ' ,
               overflow : TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w600 , 
               fontSize: 15.5 , fontFamily: '',color: defaultColor ),),
                    ],
                ),
                    
                ],
        ),
        ),
        ),
                        )??Center(child: CircularProgressIndicator(),),
           );

      
         }) 
         )
           : Scaffold(
             body: Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text('No bill yet' , style: TextStyle(color: Colors.red , fontSize: 30 , fontWeight: FontWeight.w600)),
                  SizedBox(height: 5,),
                  CircularProgressIndicator(),
                 ],
               ),
             ),
           );
        },
        );
  }
}