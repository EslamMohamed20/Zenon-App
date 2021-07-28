



abstract class CartStates {}
class CartInitialStates extends CartStates{}
class AddToCartSuccessState extends CartStates{}
class AddToCartErrorState extends CartStates{}
class UpdateCartSuccessState extends CartStates{}
class ReduceQuantityOfProductfromCart extends CartStates{}
class DeleteProductfromCart extends CartStates{}
class DeleteAllProductsfromCart extends CartStates{}


class ItemInCartState extends CartStates{}

class CalcTotalPriceOfCartSuccessState extends CartStates{}