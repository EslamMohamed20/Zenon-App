


import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final  image;
  ShowImage(this.image);

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[ Expanded(
        child: Container(
          child: InteractiveViewer(
              child: Image(image:image,),
            maxScale: 4,

          ),
        ),
      ),]
    );
  }
}


//method 
//للاختصار وانت بتتنقللها
void showImageScreen (BuildContext context , image )
{
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
      ShowImage( image ), ) , );
}

