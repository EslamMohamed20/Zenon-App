



import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zenon/models/firebase_product_model.dart';
import 'by_me_cart_model.dart';
import 'by_me_stetes.dart';
import 'package:intl/intl.dart';

class TagModel {
  final String tagId;
  final String productFullNameOnTag;
  final String productName;
  final String productId;
  final int productPrice;
  final int itemQuantity ;
  

  TagModel(
      {this.tagId,
      this.productName,
      this.productPrice,
      this.productFullNameOnTag ,
      this.itemQuantity=1 ,
      this.productId,
      
       });

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
        tagId: json["tagId"], 
        productId: json["productId"],
        productName: json["productName"],
        productPrice: json["productPrice"],
        productFullNameOnTag: json["productFullNameOnTag"],
        itemQuantity  : json["itemQuantity"]??1,
      );
}

class ByMeCubit extends Cubit<ByMeCubitStates>{
ByMeCubit():super(ByMeInitialState());  //يبدأ بيها

//علشان اقدر اعمل منه اوبجكت اقدر استخدمه ف اى  مكان
static ByMeCubit get(context) => BlocProvider.of(context);  // CounterCubit.get(context).توصل لاى حاجه جوه

//هابتدى اعرف متغيراتى بقى والفانكشن اللبتسند قيم فيها

 
   Future<bool> checkNfcTurnOn()async {
  bool supportsNFC ;
     supportsNFC = await NFC.isNDEFSupported;
     return supportsNFC ;
  }


  Map<String, dynamic> tagInfo = {};
  TagModel tagInformation;
  Map<String , TagModel> itemsDetectedByTag = {} ;
  Map<String , ByMeCartModel> cartItems = {} ;
  String barCodeScanResult ;
 // List<FirebaseProductModel> cartItems =[];

  
double total = 0.0 ;
double totalAmount () {
 total = 0.0 ;
cartItems.forEach((key, value) {total +=value.productPrice*value.productquantity ; });
emit(CalcTotalPriceOfItemDetectedSuccessState());
print(total);
return total ;
}


  void addProductToItemsDetectedByTagList (
  {
  @required String tagId,
  @required String productId,
  @required String productFullNameOnTag,
  @required String productName,
  @required int productPrice,
   //  int itemQuantity =1 ,
}) 
{
   print (itemsDetectedByTag.length);
  //if item existing in cart => quantity + 1
  if (itemsDetectedByTag.containsKey(productId)) {
    itemsDetectedByTag.update(productId, (existingCartItem) => TagModel(
     tagId:existingCartItem.tagId ,
     productId:existingCartItem.productId ,
     productFullNameOnTag:existingCartItem.productFullNameOnTag,
     productName: existingCartItem.productName ,
     productPrice:existingCartItem. productPrice ,
     itemQuantity: existingCartItem.itemQuantity +1,
          //مهم علشان اقدر اعرض العنصر ال ف العربه
    ));
    totalAmount();
   //  getProductDataFromFirebaseandFiltered();
      emit(AddItemDetectedListSuccessState());
  } else {
    itemsDetectedByTag.putIfAbsent(productId, () => TagModel(
       tagId: tagId ,
       productId: productId,
     productFullNameOnTag:productFullNameOnTag,
     productName: productName ,
     productPrice: productPrice ,
     itemQuantity: 1,
    ));
    totalAmount();
   // getProductDataFromFirebaseandFiltered();
      emit(AddItemDetectedListSuccessState());
  }

}


 StreamSubscription<NDEFTag> nfcStream ;
//then get all products from fireStroe
List<FirebaseProductModel> firebaseAllProductInfo =[];
getProductDataFromFirebaseandFiltered() async{
   emit(ByMeCubitGetProjectDataFromFirebaseLoadingState());
  

  await FirebaseFirestore.instance.collection('products')
  .get()
  .then((QuerySnapshot productsSnapshot) {
    firebaseAllProductInfo =[];
    print ('iam in product now');
    productsSnapshot.docs.forEach((element) { 
      firebaseAllProductInfo.add(FirebaseProductModel.fromJson(element.data()));
    });
     emit(ByMeCubitGetProjectDataFromFirebaseSuccessState());
      print ('products from firebase:  ${firebaseAllProductInfo[2].name}');
  }).catchError((error) {
    print(error);
    emit(ByMeCubitGetProjectDataFromFirebaseErrorState());
  });

 }

// then هات منها بيانات المنتجات اللهو اسكانها
 

 chekItemFoundedInOurDatabase(String productId){
  bool found =false ;
   if(productId!=null){
     firebaseAllProductInfo.forEach((element) { 
     if (element.productId ==productId )
     {
       found = true;
        
       // emit(DetectedItemFoundedOnOurProducts());
     }
     });

   }


   if(  itemsDetectedByTag != {}) {
  firebaseAllProductInfo .forEach((element) { 
    itemsDetectedByTag.forEach((key, value) { 
      if (element.productId== value.productId )
      {
        found = true ;
  }
    });



  });
 }

  print('item found:${found.toString()}');
  found? emit(DetectedItemFoundedOnOurProducts()):emit(DetectedItemNotFoundOnOurProducts());

 }


 filterProductAndAddDataToByMeCart({ByMeCartModel productInfo  ,List<FirebaseProductModel> firebaseAllProductInfo , String productId }){
     print('barCodeScanResult : $productId');

      if (productInfo !=null)
      {
        if(cartItems.containsKey(productInfo.productid))
        { print (productInfo.productid);
          cartItems.update(productInfo.productid, (itemExist) =>ByMeCartModel(
          firebaseproductid: itemExist.firebaseproductid,
          productFullNameOnTag: itemExist.productFullNameOnTag ,
          productImage: itemExist.productImage ,
          productName: itemExist.productName ,
          productOldPrice: itemExist.productOldPrice??0.0,
          productPrice: itemExist.productPrice,
          productid: itemExist.productid,
          productquantity: itemExist.productquantity +1 ,  // increase--
          tagId: itemExist.tagId,
        ));
           totalAmount();
           itemsDetectedByTag = {} ;
           barCodeScanResult =null;
              emit (ByMeCubitGetCartItemsDataFromFirebaseSuccessState());

        }
        else{
           cartItems.putIfAbsent(productInfo.productid, () => ByMeCartModel(
          firebaseproductid: productInfo.firebaseproductid,
          productFullNameOnTag: productInfo.productName+productInfo.productPrice.toString()+' L.E#'+' ${productInfo.productid}#',
          productImage: productInfo.productImage,
          productName: productInfo.productName,
          productOldPrice: productInfo.productOldPrice??0.0,
          productPrice: productInfo.productPrice,
          productid: productInfo.productid,
          productquantity: 1,
          tagId: productInfo.tagId,

        ));
         totalAmount();
         itemsDetectedByTag = {} ;
         barCodeScanResult = '';
                  emit (ByMeCubitGetCartItemsDataFromFirebaseSuccessState());

        }
      }
   //nfc-----------------------------------
   if (firebaseAllProductInfo!=null &&  barCodeScanResult ==null){
    chekItemFoundedInOurDatabase(productId);
  firebaseAllProductInfo.forEach((firebaseProductInfo) { 
    if (itemsDetectedByTag.containsKey(firebaseProductInfo.productId))
    {     print ('tag id from if contain${firebaseProductInfo.name}');
      if (cartItems.containsKey(firebaseProductInfo.productId))
      {
        cartItems.update(firebaseProductInfo.productId, (existingCartItem) =>ByMeCartModel(
          firebaseproductid: existingCartItem.firebaseproductid,
          productFullNameOnTag: existingCartItem.productFullNameOnTag ,
          productImage: existingCartItem.productImage ,
          productName: existingCartItem.productName ,
          productOldPrice: existingCartItem.productOldPrice??0.0,
          productPrice: existingCartItem.productPrice,
          productid: existingCartItem.productid,
          productquantity: existingCartItem.productquantity +1 ,  // increase--
          tagId: existingCartItem.tagId,
        ) );
        totalAmount();
        //print('if contain :${cartItems[firebaseProductInfo.name].productquantity}');
        itemsDetectedByTag = {} ;
         emit (ByMeCubitGetCartItemsDataFromFirebaseSuccessState());
        //emit 
      }
      else 
      {
        cartItems.putIfAbsent(firebaseProductInfo.productId, () => ByMeCartModel(
          firebaseproductid: firebaseProductInfo.firebaseId,
          productFullNameOnTag: firebaseProductInfo.name+firebaseProductInfo.price.toString()+' L.E#'+' ${firebaseProductInfo.productId}#',
          productImage: firebaseProductInfo.image,
          productName: firebaseProductInfo.name,
          productOldPrice: firebaseProductInfo.oldPrice??0.0,
          productPrice: firebaseProductInfo.price,
          productid: firebaseProductInfo.productId,
          productquantity: 1,
          tagId: firebaseProductInfo.tagId,
                 
        ));
        // print('if not contain :${cartItems[firebaseProductInfo.name].productquantity}');
         totalAmount();
         itemsDetectedByTag = {} ;
                 emit (ByMeCubitGetCartItemsDataFromFirebaseSuccessState());

      }
    }
  });
   }
  
 //bar code--------------------------
  if ( firebaseAllProductInfo!=null && productId!=null && productInfo ==null ){
    chekItemFoundedInOurDatabase(productId);
  firebaseAllProductInfo.forEach((firebaseProductInfo) { 
    if (productId ==firebaseProductInfo.productId )
    {     print ('tag id from if serial contain${firebaseProductInfo.productId}');
      if (cartItems.containsKey(firebaseProductInfo.productId))
      {
        cartItems.update(firebaseProductInfo.productId, (existingCartItem) =>ByMeCartModel(
          firebaseproductid: existingCartItem.firebaseproductid,
          productFullNameOnTag: existingCartItem.productFullNameOnTag ,
          productImage: existingCartItem.productImage ,
          productName: existingCartItem.productName ,
          productOldPrice: existingCartItem.productOldPrice??0.0,
          productPrice: existingCartItem.productPrice,
          productid: existingCartItem.productid,
          productquantity: existingCartItem.productquantity +1 ,  // increase--
          tagId: existingCartItem.tagId,
        ) );
        totalAmount();
        barCodeScanResult=null;
         emit (ByMeCubitGetCartItemsDataFromFirebaseSuccessState());
        //emit 
      }
      else 
      {
        cartItems.putIfAbsent(firebaseProductInfo.productId, () => ByMeCartModel(
          firebaseproductid: firebaseProductInfo.firebaseId,
          productFullNameOnTag: firebaseProductInfo.name+firebaseProductInfo.price.toString()+' L.E#'+' firebaseProductInfo.productId#',
          productImage: firebaseProductInfo.image,
          productName: firebaseProductInfo.name,
          productOldPrice: firebaseProductInfo.oldPrice??0.0,
          productPrice: firebaseProductInfo.price,
          productid: firebaseProductInfo.productId,
          productquantity: 1,
          tagId: firebaseProductInfo.tagId,
                 
        ));
         totalAmount();
         barCodeScanResult=null;
           emit (ByMeCubitGetCartItemsDataFromFirebaseSuccessState());

      }
  
  }
  
  });
   }

   
 }

//BymeOrderConfirmModel
uploadByMeOrderWithCardConfirmationToFirebase(
  {@required String zenonCardId,
   @required String orderNumber,
    bool orderDone = true,
   @required double totalAmount
  }
  )async{
  
  await FirebaseFirestore.instance.collection('orderConfirmationWithZenonCard')
  .doc(zenonCardId).set({
    'cardId':zenonCardId,
    'orderNumber': orderNumber??zenonCardId,
     'orderDone': orderDone ??true,
     'totalAmount': totalAmount??0.0
  }).then((value) {
    emit(UploadByMeOrderWithCardConfirmationToFirebaseSuccessState());
  } 
  ).catchError((error)
  {
     emit(UploadByMeOrderWithCardConfirmationToFirebaseErrorState());
  });

}


DatabaseReference ref = FirebaseDatabase().reference();
setOrderConfermationCardIDAndTotalAmountRealtimeDatabase({
  String cardId ,
  double totalAmount }) async{
    emit (SetOrderConfermationCardIDAndTotalAmountRealtimeDatabaseLoadingState());
    DateTime date = DateTime.now();
    
await ref.update({
  cardId:totalAmount,
}).then((value){
  emit(SetOrderConfermationCardIDAndTotalAmountRealtimeDatabaseSuccessState());
}).catchError((error)
{
  print(error);
  emit(SetOrderConfermationCardIDAndTotalAmountRealtimeDatabaseErrorState());
});
}

Map<dynamic , dynamic> realtimeProducts ={};
Map<dynamic , dynamic> removedProducts ={};
List<dynamic > realtimeProductsList =[];
List<dynamic > removedProductsList =[];
int billTotalAmount = 0;
int currentCardAmount =0; 
getOrderBillFromRealTimeDatabase()async {
 realtimeProducts ={};
 removedProducts ={};
  realtimeProductsList =[];
 removedProductsList =[];
 billTotalAmount = 0;
 currentCardAmount =0; 
  emit(GetOrderBillFromRealTimeDatabasLoadingState());
 await  ref.child('productsNames').get().then((value)async {
    //  productNames.add(value.value);
    print(value.value);
    realtimeProducts.addAll(value.value);
    realtimeProductsList.addAll(realtimeProducts.values);
    print('list: ${realtimeProductsList}');
    //emit(Test());
        await  ref.child('totalAmount').get().then((value) async  {
    print(value.value);
    billTotalAmount=value.value ; 
    await ref.child('cardAmount').get().then((value) async{
     currentCardAmount = value.value;
     await ref.child('removed').get().then((value) {
     removedProducts.addAll(value.value??'no');
     removedProductsList.addAll(removedProducts.values);
     print('list2: ${removedProductsList}');
    
    int i=0;
    realtimeProductsList.forEach((realTimeElement) { 
      removedProductsList.forEach((removedElement) { 
         if(removedElement==realTimeElement)
         {
          realtimeProductsList[i]='';
         }
      });
      i++;
    });
    print (realtimeProductsList);
     
     
     emit(GetOrderBillFromRealTimeDatabaseSuccessState());
    });
     
    });
  });
  });
   
}


void removeItemFromDetectedByTagList({@required String productId})
{
  print(productId);
  cartItems.remove(productId);
  itemsDetectedByTag.remove(productId);
  totalAmount();
  emit(DeleteProductfromCartDetectedListSuccessState());
}



void removeAllItemFromCart ()
{
  cartItems.clear();
  itemsDetectedByTag.clear();
   barCodeScanResult=null;
  total=0;
  emit(DeleteAllProductsfromByMeCartSuccesState());
}


void reduceQuantityOfProductfromDetectedByTagList(
  {
 @required String productId, 
}) 
{    
  
    cartItems.update(productId, (existingCartItem) =>ByMeCartModel(
          firebaseproductid: existingCartItem.firebaseproductid,
          productFullNameOnTag: existingCartItem.productFullNameOnTag ,
          productImage: existingCartItem.productImage ,
          productName: existingCartItem.productName ,
          productOldPrice: existingCartItem.productOldPrice??0.0,
          productPrice: existingCartItem.productPrice,
          productid: existingCartItem.productid,
          productquantity: existingCartItem.productquantity -1 ,  // increase--
          tagId: existingCartItem.tagId,
        ) );
      
    totalAmount();
     print ('sen name : $productId');
     cartItems.forEach((key, value) {
       print('firebaseproductid: ${value.firebaseproductid}');
        print('productFullNameOnTag: ${value.productFullNameOnTag}');
         print('productImage: ${value.productImage}');
          print('productName: ${value.productName}');
           print('productOldPrice: ${value.productOldPrice}');
            print('productPrice: ${value.productPrice}');
             print('productid: ${value.productid}');
              print('productquantity: ${value.productquantity}');
              print('tagId: ${value.tagId}');

     });

      emit(ReduceQuantityOfProductfromCartDetectedListSuccessState());
  
 // emit(AddToCartSuccessState());
}




}

