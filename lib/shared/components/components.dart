
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/modules/favourites/favourite_product_detail_screen.dart';
import 'package:zenon/modules/products/product_details.dart';
import 'package:zenon/shared/styles/colors.dart';


class DefaultFormField extends StatefulWidget {
  final TextEditingController controller ;
  final TextInputType keyboardType;
  final String label;
  final String hint;
  final double fontSize ;
  final Color textColor ;
  final TextInputFormatter inputFormatter ;
  final FontWeight textWeight;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final BorderRadius borderRadius ;
  final Function(String) validator;
  final Function(String) onSaved;
  final Function(String) onChanged;
  final Function onTap ;
  final double errorheight;
  final TextInputAction textInputAction;
  final TextStyle hintStyle;
  final TextAlignVertical textAlignVertical;
  final Function(String) onSubmit;
   bool isCLickable ;
   final EdgeInsets contentPadding;
  final bool obscure; 
 DefaultFormField({
   @required this.controller,
   @required  this.keyboardType,
    this.label,
   @required this.hint,
    this.prefixIcon,
    this.suffixIcon ,
    this.fontSize,
    this.inputFormatter,
    this.textColor,
    this.textAlignVertical,
    this.textWeight ,
    this.borderRadius,
    this.hintStyle,
    this.contentPadding,
    this.textInputAction,
    this.onChanged,
   @required this.validator,
    this.onSaved,
    this.errorheight,
    this.onTap ,
    this.onSubmit,
    this.isCLickable =true ,
    this.obscure = false,
  });
  @override
  _DefaultFormFieldState createState() => _DefaultFormFieldState();
}

class _DefaultFormFieldState extends State<DefaultFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical:widget.textAlignVertical,

    controller: widget.controller,
    keyboardType: widget.keyboardType,
   style: TextStyle(fontSize:widget.fontSize , 
   color: widget.textColor  , fontWeight: widget.textWeight),
  //inputFormatters: [widget.inputFormatter]??FilteringTextInputFormatter.allow(''),
   decoration: InputDecoration(
     
      errorStyle: TextStyle(height: widget.errorheight),
      labelText: widget.label,
      hintText: widget.hint,
      hintStyle:widget.hintStyle ,
      contentPadding:widget.contentPadding,
      prefixIcon:widget.prefixIcon ,
      suffixIcon:widget.suffixIcon,
      
      border: OutlineInputBorder(borderRadius: widget.borderRadius??BorderRadius.circular(4.0),),
     // borderRadius:widget.borderRadius =BorderRadius.circular(4.0),
        ) ,
    
    
    validator: widget.validator,
    textInputAction:widget.textInputAction,
    onSaved: widget.onSaved,
    onChanged: widget.onChanged,
    obscureText: widget.obscure,
    onTap: widget.onTap,
    onFieldSubmitted:widget.onSubmit ,
    enabled: widget.isCLickable,


   
  );
  }
}

//---------------------------------------------------------------------

Widget defaultButton({
  double width = double.infinity,
  double height = 50 ,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  TextStyle textStyle ,
  @required Function function,
  @required String text,
}) =>
    Container(
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: textStyle ,
      ),),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

//---------------------------------------------------------------------------------------
Widget defaultTextButton ({
  @required Function onpressed,
  @required String text,
  TextStyle textStyle,
}){
  return  TextButton(
                  onPressed: onpressed, 
                  child: Text(text.toUpperCase() , style:textStyle ,),);
}
 
 //---------------------------------------------------------------------

 Future<bool> defaultFlutterToast ({
   @required String massege ,
   @required double fontSize,
   Toast toasttimelenght =Toast.LENGTH_LONG ,
   ToastGravity toastpossition = ToastGravity.BOTTOM ,
   int timeInSecForIosWeb = 5 ,
   Color backgroundColor = Colors.blue,
   Color textColor: Colors.white ,
 })  
{
  return 
   Fluttertoast.showToast(
                  msg: massege,
                  toastLength: toasttimelenght,
                  gravity: toastpossition,
                  timeInSecForIosWeb: timeInSecForIosWeb,
                  backgroundColor: backgroundColor,
                  textColor:textColor,
                  fontSize:fontSize);
}
//-----------------------------------------------------------------------------------

 Future defaultAlertDialog ({BuildContext context ,String title  ,String subTitle , Function fun , bool showSeconedBUTTON = true}) 
{
  showDialog(context: context,
   builder: (context ) 
   {
     return AlertDialog(
       title:Row(
         children: [
           Icon(Icons.warning,
           color: Colors.red,
           size: 30,),

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text('$title' ,style: TextStyle(fontWeight: FontWeight.w700),)
           ),


         ],
       ),
       content:Text('$subTitle' ,style: TextStyle(fontWeight: FontWeight.w600)) ,
       actions:
        [   if (showSeconedBUTTON)
           TextButton(onPressed: () {
              fun();
             Navigator.of(context).pop();
           } , child: Text('Yes' , style: TextStyle(fontWeight: FontWeight.w500 , color: Colors.red),)),
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text('Cancel' ,style: TextStyle(fontWeight: FontWeight.w500))),
        ],
     );
   });
}
//-------------------------------------------------------------------------------
// Search screen

Widget buildListViewItem(dynamic itemModel ,BuildContext context , int id  ,  {bool isOldPrice = true} )
  {   isOldPrice?itemModel.discount=itemModel.discount:itemModel.discount=0;

    return InkWell(
          onTap: (){
          Navigator.of(context).
          push(MaterialPageRoute(builder: (context ) => FavouriteProductDetailsScreen(id:id,)));
          },
          child: Container(
        color:  Colors.white,
        //Colors.lime[50].withOpacity(0.1),
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
                      itemModel.image),
                //  fit: BoxFit.cover,
                  width: 148,
                  height: 160,
                ),
                //discount
                if (itemModel.discount != 0 && isOldPrice )
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
                    itemModel.name,
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
                        '${itemModel.price}',
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
                      if (itemModel.discount != 0 && isOldPrice)
                        Row(
                          children: [
                            Text(
                              '${itemModel.oldPrice}',
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
                        isLiked:HomeCubit.get(context).favourites[itemModel.id],
                        onTap: (val) async {
                        HomeCubit.get(context).changeFavourites(itemModel.id);
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
      ),
    );
  
  }


