

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenon/models/cart_model.dart';
import 'package:zenon/modules/cart/cubit/cart_states.dart';

class CartCubit extends Cubit<CartStates>{
CartCubit():super(CartInitialStates());  //يبدأ بيها

//علشان اقدر اعمل منه اوبجكت اقدر استخدمه ف اى  مكان
static CartCubit get(context) => BlocProvider.of(context);  // CartCubit.get(context).توصل لاى حاجه جوه

//هابتدى اعرف متغيراتى بقى والفانكشن اللبتسند قيم فيها


Map<String , CartModel> cartItems = {} ;


//الفاتوره الكليه كااااام

double total = 0.0 ;
double totalAmount () {
 total = 0.0 ;
cartItems.forEach((key, value) {total +=value.price*value.quantity ; });
emit(CalcTotalPriceOfCartSuccessState());
print(total);
return total ;
}

// ضيف المنتجات للعربه
void addProductToCart (
  {
  @required String name , 
  @required String id , 
  @required double price , 
  @required int discount ,
   int index ,
  @required double oldPrice , 
  @required String image,
}) 
{
  //if item existing in cart => quantity + 1
  if (cartItems.containsKey(id)) {
    cartItems.update(id, (existingCartItem) => CartModel(
      id: existingCartItem.id ,
      image: existingCartItem.image,
      name: existingCartItem.name,
      price: existingCartItem.price,
      oldPrice: existingCartItem.oldPrice??0.0,
      quantity: existingCartItem.quantity +1 ,  
      discount: existingCartItem.discount,
      index:index ,    //مهم علشان اقدر اعرض العنصر ال ف العربه
    ));
    totalAmount();
      emit(AddToCartSuccessState());
  } else {
    cartItems.putIfAbsent(id, () => CartModel(
      id:id ,   //unique number
      image: image,
      name: name,
      price: price,
      oldPrice: oldPrice??0.0,
      discount:discount ,
      quantity: 1 ,  
      index:index,

    ));
    totalAmount();
      emit(AddToCartSuccessState());
  }
 // emit(AddToCartSuccessState());
}


checkItemInCart(String id) {
   if (cartItems.containsKey(id)) {
   emit(ItemInCartState());
}

}


void reduceQuantityOfProductfromCart (
  {
  @required String name , 
  @required String id , 
  @required double price , 
  @required int discount ,
  @required int index ,
  @required double oldPrice , 
  @required String image,
}) 
{
 
    cartItems.update(id, (existingCartItem) => CartModel(
      id: existingCartItem.id ,
      image: existingCartItem.image,
      name: existingCartItem.name,
      price: existingCartItem.price,
      oldPrice: existingCartItem.oldPrice??0.0,
      quantity: existingCartItem.quantity -1 ,  
      discount: existingCartItem.discount,
      index:index ,    //مهم علشان اقدر اعرض العنصر ال ف العربه
    ));
    totalAmount();
      emit(ReduceQuantityOfProductfromCart());
  
 // emit(AddToCartSuccessState());
}


void removeItemFromCart ({@required String id})
{
  cartItems.remove(id);
  emit(DeleteProductfromCart());
}

void removeAllItemFromCart ()
{
  cartItems.clear();
  emit(DeleteAllProductsfromCart());
}



}
