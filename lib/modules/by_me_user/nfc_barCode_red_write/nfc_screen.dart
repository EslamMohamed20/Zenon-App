

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:toast/toast.dart';
import 'package:zenon/models/firebase_product_model.dart';
import 'package:zenon/modules/by_me_user/by_me_cubit/by_me_cart_model.dart';
import 'package:zenon/modules/by_me_user/by_me_cubit/by_me_cubit.dart';
import 'package:zenon/modules/by_me_user/by_me_cubit/by_me_stetes.dart';
import 'package:zenon/shared/components/components.dart';
import 'package:zenon/shared/components/constants.dart';
import 'package:zenon/shared/styles/colors.dart';


class NfcScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey ;

  const NfcScreen({this.scaffoldKey}) ;
  @override
  _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State<NfcScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ByMeCubit ,ByMeCubitStates>(
      listener: (context , state){
        if(state is DetectedItemNotFoundOnOurProducts)
        {
          Toast.show('This item not found in our products', context , duration: 3 , backgroundColor: Colors.red);
        }
      },
      builder:  (context , state)
      {
        var byMeCubit = ByMeCubit.get(context);
        return   Scaffold(
          key: _scaffoldKey,
                  body: Container(
       //   height: MediaQuery.of(context).size.height*0.8,
            child: Column (
      mainAxisSize: MainAxisSize.min,
      children: [
       Container(
          height: MediaQuery.of(context).size.height * 0.76,
              // color: Colors.blue,
      margin: const EdgeInsets.only(bottom: 6),
      child:  byMeCubit.cartItems.length>0?ListView.separated(
                 itemCount:byMeCubit.cartItems.length ,
                // byMeCubit.itemsDetectedByTag.length,
                itemBuilder: (BuildContext context , index) { return buildCartItem(context:context ,
                byMeCubit:byMeCubit ,
                items:byMeCubit.cartItems,
               // byMeCubit.itemsDetectedByTag ,
                 index: index )  ;},
              separatorBuilder:  (BuildContext context , index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(height: 0, color: defaultColor,)),):
                   Column (children: [
                        SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/emptyCart.png'),
              )),
            ),
          ),
          Text(
            'Your Cart Is Empty!!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Looks Like You didn\'t\n add anything to your cart yet!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 20,
                  color: isdarkTheme ? Colors.white70 : Colors.grey[600],
                ),
          ),
          SizedBox(
            height: 30,
          ),
           Text(
            'Please, click Add new item button below and scan your items one by one.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 20,
                  color: isdarkTheme ? Colors.white70 : defaultColor.withOpacity(0.6),
                ),
          ),
          
         
                   ],),
   
    ) ,

     Center(
    child:Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),
        border:Border.all(color: Colors.redAccent , width: 1.5)),
      child: defaultButton(function: () async {
      nfcReadResponse(ctx:widget.scaffoldKey.currentContext ,items:byMeCubit.cartItems ,byMeCubit: byMeCubit,  //byMeCubit.itemsDetectedByTag
       supportsNFC:await byMeCubit.checkNfcTurnOn()) ;
     
    } ,
       text: 'Add new item' ,  height: 40 , 
               textStyle: TextStyle(fontWeight: FontWeight.w600 , color: Colors.white, ), 
               background: defaultColor ,  width: MediaQuery.of(context).size.width*0.35 ),
    ),
   
    
    
    
     )], 
    ),
          ),
        );
    
    
      }, );
    
   }

   nfcReadResponse ({BuildContext ctx , bool supportsNFC , Map<String , ByMeCartModel>  items , ByMeCubit byMeCubit
   }) async {
     if (!supportsNFC) {
    await  defaultAlertDialog(title: 'NFC Alert' ,
     subTitle: "To continue, turn on NFC in your device Or scan your items with BarCode",
     context:context , 
    showSeconedBUTTON: false);
    }
    else {
     await  showDialog(context: ctx, 
      builder: (context) {
         Stream<NDEFMessage> _stream = NFC.readNDEF( once: true);
           
            //  _stream = NFC
            //         .readNDEF(
            //             once: true,
            //             throwOnUserCancel: false,
            //             alertMessage: 'readed'
            //             )
                  _stream.listen(
                      (
                  NDEFMessage message,
                ){
                  print("read NDEF message: ${message.records.first}");
                  print("read NDEF message: ${message.type}");
                   print("read NDEF Id: ${message.id}");
                 
                  print("read NDEF message: ${message.payload}");
                  print("read NDEF message: ${message.messageType}");
                  print("read NDEF message: ${message.id}");
                  print("read NDEF message: ${message.data}");
                  List dataSplited = message.data.split(" ");
                  print(dataSplited);
                  byMeCubit.tagInfo = {
                    'tagId': message.tag.id.trim(),
                    'productName': dataSplited[0].toString().trim(),
                    'productPrice': int.parse(dataSplited
                        .sublist(1, 2)[0]
                        .toString()
                        .split('L')[0]
                        .toString().trim()),
                    'productId' : dataSplited
                        .sublist(2, 3)[0]
                        .toString().trim()
                        .split('#')[0]
                        .toString(),
                    'productFullNameOnTag': message.data,
                  };
                  byMeCubit.tagInformation = TagModel.fromJson(byMeCubit.tagInfo);
                  //  print('productName : ${tagInfo['productName']}');
                  //  print('productPrice : ${tagInfo['productPrice']}');
                  print (dataSplited
                        .sublist(2, 3)[0]
                        .toString().trim()
                        .split('#')[0]
                        .toString(),);
                  print('productName : ${byMeCubit.tagInformation.productName}');
                  print('productPrice : ${byMeCubit.tagInformation.productPrice}');
                  print('TagId : ${byMeCubit.tagInformation.tagId.toString()}');
                  print('productFullNameOnTag : ${byMeCubit.tagInformation.productFullNameOnTag}');
                }, 
                onError: (error) {
                  // Check error handling guide below
                  print("read NDEF message: ${error.toString()}");
                  Toast.show('${error.toString()}', ctx ,  gravity: 1 , duration: 4 , backgroundColor: Colors.red);
                },
                 onDone: () {
                  print('done');
                   byMeCubit.addProductToItemsDetectedByTagList(tagId:byMeCubit.tagInformation.tagId.toString(),
         productFullNameOnTag: byMeCubit.tagInformation.productFullNameOnTag,productId:byMeCubit.tagInformation.productId.toString() ,
          productName: byMeCubit.tagInformation.productName, productPrice: byMeCubit.tagInformation.productPrice ,
          );
            byMeCubit.filterProductAndAddDataToByMeCart(firebaseAllProductInfo:byMeCubit.firebaseAllProductInfo );
                 //  _stream.pause();  => if   StreamSubscription<NDEFMessage> _stream;
           Navigator.of(context).canPop()?
           Navigator.of(context).pop():null;
                },
                
                );
             
          
        return AlertDialog(
          scrollable: true,
         title: Row(
         children: [
           Icon(Icons.nfc,
           color: Colors.green,
           size: 30,),

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text('Scan your item' ,style: TextStyle(fontWeight: FontWeight.w700),)
           ),


         ],
       ),
           actions: [
          //     TextButton(onPressed: () {
          //        //----------------------
          //    Navigator.of(context).pop();
          //  } , 
          // child: Text('Yes' , style: TextStyle(fontWeight: FontWeight.w500 , color: Colors.red),)),
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text('Cancel' ,style: TextStyle(fontWeight: FontWeight.w500))),
        
           ],
           content:Column (
               children: [
                 Text('Please Put your phone on Zenon label on the package' ,
                 style:  TextStyle(fontWeight: FontWeight.w600),),
                 SizedBox(height:10 ,),
                 Image(image: AssetImage('assets/images/zenonNfc.png')
                 ,height: 230,
                 width: 230
                 , fit: BoxFit.fill,
                 //MediaQuery.of(context).size.width*0.6,fit: BoxFit.fill,
                 ),
                 
               ],
             ) ,

           
        );
      }
      );
    }

   }



   // ByMeCubit byMeCubit
  Widget buildCartItem ({ Map<String , ByMeCartModel>  items, ByMeCubit byMeCubit ,  BuildContext context , index}){
    return Container(
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
                      image:items.values.toList()[index].productImage ==null?
                      AssetImage('assets/images/emptyCart.png'):
                       NetworkImage(
                        '${items.values.toList()[index].productImage}',
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
                                '${items.values.toList()[index].productName}',
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
                                   byMeCubit.removeItemFromDetectedByTagList(productId:  items.values.toList()[index].productid);
                                  // HomeCubit.get(context).removeItemFromCartProductScreen();
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
                              '${items.values.toList()[index].productPrice}',
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
                            if (byMeCubit.cartItems.values.toList()[index].productOldPrice !=0.0)
                              Text(
                                '${items.values.toList()[index].productOldPrice}',
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
                            if (items.values.toList()[index].productOldPrice !=0.0)
                              SizedBox(
                                width: 2,
                              ),
                            if (items.values.toList()[index].productOldPrice  !=0.0)
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
                           Spacer(),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                   items.values.toList()[index].productquantity<2 ? null :
                                  byMeCubit.reduceQuantityOfProductfromDetectedByTagList(
                                    
                                    productId: items.values.toList()[index].productid,
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
                                      items.values.toList()[index].productquantity<2 ?
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
                                  '${items.values.toList()[index].productquantity}',
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
                                 items.values.toList()[index].productquantity>=10 ?
                                  Toast.show('It\'s Limited by 10 Items', context ,backgroundColor: Colors.red  ,
                                  duration:4) :
                                  byMeCubit.filterProductAndAddDataToByMeCart(productInfo:items.values.toList()[index] );
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
                                      color: items.values.toList()[index].productquantity>=10 ?Colors.grey :
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
          );
       
  }
}
