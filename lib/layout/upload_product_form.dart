import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:toast/toast.dart';
import 'package:zenon/layout/home_cubit/home_cubit.dart';
import 'package:zenon/layout/home_cubit/home_states.dart';
import 'package:zenon/modules/by_me_user/by_me_cubit/by_me_cubit.dart';
import 'package:zenon/shared/components/components.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _productTitle = '';
  var _productPrice = '';
  var _productOldPrice = '';
  var _productCategory = '';
  var _productSerialNumber = '';
  var _productTagIdNumber = '';
  var _productBrand = '';
  var _productDescription = '';
  var _productQuantity = '';
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _productSerialNumberController =
      TextEditingController();
  final TextEditingController _productTagIdController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();


  String _categoryValue;
  String _brandValue;

  showAlertDialog(BuildContext context, String title, String body) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _formKey.currentState.save();
        HomeCubit.get(context).uploadProductInfoOnFireStore(
          productId: _productSerialNumber,
          tagId: _productTagIdNumber,
          name: _productTitle,
          description: _productDescription,
          price: double.parse(_productPrice),
          oldPrice: double.parse(_productOldPrice),
          categoryName: _productCategory,
          prandName: _productBrand,
          quantatity: int.parse(_productQuantity),
          image: HomeCubit.get(context).imageUrl,
          images: HomeCubit.get(context).imagesUrl,
        );
      });

      // Use those values to send our auth request ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is UploadProductInfoOnFireStoreSuccessState) {
          Toast.show('Uploaded Successfully', context,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              duration: 4);
          if (Navigator.of(context).canPop()) {
            HomeCubit.get(context).pickedImage = null;
            HomeCubit.get(context).imageUrl = null;
             HomeCubit.get(context).imagesUrl= <String>[];
  // assetImages =<AssetEntity>[] ; 
HomeCubit.get(context).assetImages = <Asset>[] ; 
HomeCubit.get(context).fileImages  =<File>[];   
           setState(() {
              _productTitle = '';
            _productPrice = '';
            _productOldPrice = '';
            _productCategory = '';
            _productSerialNumber = '';
            _productTagIdNumber = '';
            _productBrand = '';
            _productDescription = '';
            _productQuantity = '';
            _categoryController.clear();
            _brandController.clear();
            _productSerialNumberController.clear();
            _productTagIdController.clear();
            _titleController.clear();
           });
           
          }

          //  Navigator.of(context).canPop()?Navigator.of(context).pop():null;
        }
        if (state is UploadProductInfoOnFireStoreErrorState) {
          Toast.show('Failed', context,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              duration: 3);
        }
      },
      builder: (context, state) {
        var uploadCubit = HomeCubit.get(context);

        return Scaffold(
          key: _scaffoldKey,
          bottomSheet: Container(
            height: kBottomNavigationBarHeight * 0.8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: Material(
              color: Theme.of(context).backgroundColor,
              child: InkWell(
                onTap: _trySubmit,
                splashColor: Colors.grey,
                child: state is! UploadProductInfoOnFireStoreLoadingState
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Text('Upload',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center),
                          ),
                          GradientIcon(
                            Feather.upload,
                            20,
                            LinearGradient(
                              colors: <Color>[
                                Colors.green,
                                Colors.yellow,
                                Colors.deepOrange,
                                Colors.orange,
                                Colors.yellow[800]
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ],
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Card(
                    margin: EdgeInsets.all(15),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //product title --------------------------
                                Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: TextFormField(
                                      controller: _titleController,
                                      key: ValueKey('Title'),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter a Title';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText: 'Product Title',
                                      ),
                                      onSaved: (value) {
                                        _productTitle = value;
                                      },
                                    ),
                                  ),
                                ),
                                //  Spacer(),
                                //price & old price
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      //price ----------------
                                      Flexible(
                                        flex: 1,
                                        child: TextFormField(
                                          key: ValueKey('Price EGP'),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Price is missed';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'Price EGP',
                                          ),
                                          //obscureText: true,
                                          onSaved: (value) {
                                            _productPrice = value;
                                          },
                                        ),
                                      ),
                                      // old price  _productOldPrice
                                      Flexible(
                                        flex: 1,
                                        child: TextFormField(
                                          key: ValueKey('OldPrice EGP'),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Price is OldPrice';
                                            }
                                            return null;
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'OldPrice EGP',
                                          ),
                                          //obscureText: true,
                                          onSaved: (value) {
                                            _productOldPrice = value ?? 0.0;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            /* Image picker here ***********************************/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  //  flex: 2,
                                  child: uploadCubit.pickedImage == null
                                      ? Container(
                                          margin: EdgeInsets.all(10),
                                          height: 200,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Theme.of(context)
                                                .backgroundColor,
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.all(10),
                                          height: 200,
                                          width: 200,
                                          child: Container(
                                            height: 200,
                                            // width: 200,
                                            decoration: BoxDecoration(
                                              // borderRadius: BorderRadius.only(
                                              //   topLeft: const Radius.circular(40.0),
                                              // ),
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                            ),
                                            child: Image.file(
                                              uploadCubit.pickedImage,
                                              fit: BoxFit.contain,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                ),
                                //upload image button
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        'Main Image',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    //from camera
                                    FittedBox(
                                      child: FlatButton.icon(
                                        textColor: Colors.white,
                                        onPressed: () => uploadCubit.getImage(
                                            src: ImageSource.camera,
                                            uploadChildFolderName:
                                                '${_titleController.text}',
                                            uploadMainFolderName: 'products'),
                                        icon: Icon(Icons.camera,
                                            color: Colors.purpleAccent),
                                        label: Text(
                                          'Camera',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .textSelectionColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    //from gallery
                                    FittedBox(
                                      child: FlatButton.icon(
                                        textColor: Colors.white,
                                        onPressed: () => uploadCubit.getImage(
                                            src: ImageSource.gallery,
                                            uploadChildFolderName:
                                                '${_titleController.text}',
                                            uploadMainFolderName: 'products'),
                                        icon: Icon(Icons.image,
                                            color: Colors.purpleAccent),
                                        label: Text(
                                          'Gallery',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .textSelectionColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    //remove image
                                    FittedBox(
                                      child: FlatButton.icon(
                                        textColor: Colors.white,
                                        onPressed: () =>
                                            uploadCubit.removeImage(),
                                        icon: Icon(
                                          Icons.remove_circle_rounded,
                                          color: Colors.red,
                                        ),
                                        label: Text(
                                          'Remove',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                    //multible image
                                    FittedBox(
                                      child: Text(
                                        'More Images',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    state is! GarpgeState
                                        ? FittedBox(
                                            child: FlatButton.icon(
                                              textColor: Colors.white,
                                              onPressed: () =>
                                                  uploadCubit.getImagesAssets(
                                                      mainFolderName:
                                                          'products',
                                                      childFolderName:
                                                          '${_titleController.text}',
                                                      context: _scaffoldKey
                                                          .currentContext),
                                              icon: Icon(
                                                  Icons.add_a_photo_outlined,
                                                  color: Colors.purpleAccent),
                                              label: Text(
                                                'Add More',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                      .textSelectionColor,
                                                ),
                                              ),
                                            ),
                                          )
                                        : FittedBox(
                                            child: FlatButton.icon(
                                              textColor: Colors.white,
                                              onPressed: () =>
                                                  uploadCubit.getImagesAssets(
                                                      mainFolderName:
                                                          'products',
                                                      childFolderName:
                                                          _productTitle,
                                                      context: _scaffoldKey
                                                          .currentContext),
                                              icon: Icon(
                                                  Icons
                                                      .library_add_check_outlined,
                                                  color: Colors.purpleAccent),
                                              label: Text(
                                                'Add More',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                      .textSelectionColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                    
                                   
                                  ],
                                ),
                              ],
                            ),
                            if(uploadCubit.fileImages.isNotEmpty && uploadCubit.imagesUrl.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [  FittedBox( 
                                      child:  Container(
                                       // margin: EdgeInsets.all(15),
                                       width: MediaQuery.of(context).size.width*0.8,
                                        height: 70,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          padding:EdgeInsets.all(3) ,
                                          scrollDirection: Axis.horizontal,
                                          itemCount:uploadCubit.fileImages.length -1,
                                          itemBuilder: (context , index ){
                                             
                                          return Container(
                                             height: 70,
                                             margin: EdgeInsets.all(2),
                                             width: 82,
                                             decoration: BoxDecoration(
                                               // borderRadius: BorderRadius.only(
                                               //   topLeft: const Radius.circular(40.0),
                                               // ),
                                               color: Theme.of(context)
                                                   .backgroundColor,
                                             ),
                                             child: Image.file(
                                               uploadCubit.fileImages[index+1],
                                               fit: BoxFit.contain,
                                               alignment: Alignment.center,
                                             ),
                                           );
                                          }
                                      ),
                                      )
                                      
                                    ),
                                   
                              ],
                            ),
                            //    SizedBox(height: 5),
                            //category------------------------
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //catergory
                                Expanded(
                                  // flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: Container(
                                      child: TextFormField(
                                        controller: _categoryController,
                                        key: ValueKey('Category'),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter a Category';
                                          }
                                          return null;
                                        },
                                        //keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: 'Add a new Category',
                                        ),
                                        onSaved: (value) {
                                          _productCategory = value;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                DropdownButton<String>(
                                  items: [
                                    DropdownMenuItem<String>(
                                      child: Text('Mobiles'),
                                      value: 'Mobiles',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Electronics'),
                                      value: 'Electronics',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Accessories'),
                                      value: 'Accessories',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Toys'),
                                      value: 'Toys',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Furniture'),
                                      value: 'Furniture',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Computers'),
                                      value: 'Computers',
                                    ),
                                  ],
                                  onChanged: (String value) {
                                    setState(() {
                                      _categoryValue = value;
                                      _categoryController.text = value;
                                      //_controller.text= _productCategory;
                                      print(_productCategory);
                                    });
                                  },
                                  hint: Text('Select a Category'),
                                  value: _categoryValue,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            //prand--------------------------------------
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: Container(
                                      child: TextFormField(
                                        controller: _brandController,

                                        key: ValueKey('Brand'),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Brand is missed';
                                          }
                                          return null;
                                        },
                                        //keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: 'Brand',
                                        ),
                                        onSaved: (value) {
                                          _productBrand = value;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                DropdownButton<String>(
                                  items: [
                                    DropdownMenuItem<String>(
                                      child: Text('Brandless'),
                                      value: 'Brandless',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Addidas'),
                                      value: 'Addidas',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Apple'),
                                      value: 'Apple',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Dell'),
                                      value: 'Dell',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('H&M'),
                                      value: 'H&M',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Nike'),
                                      value: 'Nike',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Samsung'),
                                      value: 'Samsung',
                                    ),
                                    DropdownMenuItem<String>(
                                      child: Text('Huawei'),
                                      value: 'Huawei',
                                    ),
                                  ],
                                  onChanged: (String value) {
                                    setState(() {
                                      _brandValue = value;
                                      _brandController.text = value;
                                      print(_productBrand);
                                    });
                                  },
                                  hint: Text('Select a Brand'),
                                  value: _brandValue,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            // //serial number--------------------------------
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //serial number
                                Expanded(
                                  // flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: Container(
                                      child: TextFormField(
                                        controller:
                                            _productSerialNumberController,
                                        key: ValueKey('Product Serial Number'),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter a Serial Number';
                                          }
                                          return null;
                                        },
                                        //keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: 'Add a Serial Number',
                                        ),
                                        onSaved: (value) {
                                          _productSerialNumber = value;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.camera_alt_outlined),
                                    onPressed: () {
                                      scanBarcode(
                                          ctx: _scaffoldKey.currentContext,
                                          cubit: uploadCubit);
                                    }),
                              ],
                            ),
                            SizedBox(height: 10),
                            // //RFIDTagId number--------------------------------
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //RFIDTagId number
                                Expanded(
                                  // flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: Container(
                                      child: TextFormField(
                                        controller: _productTagIdController,
                                        key: ValueKey('Product Tag ID'),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter a Tag ID';
                                          }
                                          return null;
                                        },
                                        //keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: 'Add a Tag ID',
                                        ),
                                        onSaved: (value) {
                                          _productTagIdNumber = value;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.nfc_rounded),
                                    onPressed: () async => nfcReadResponse(
                                        ctx: _scaffoldKey.currentContext,
                                        homeCubit: uploadCubit,
                                        supportsNFC: await uploadCubit
                                            .checkNfcTurnOn())),
                              ],
                            ),
                            SizedBox(height: 20),
                            //description------------------------------
                            TextFormField(
                                key: ValueKey('Description'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'product description is required';
                                  }
                                  return null;
                                },
                                //controller: this._controller,
                                maxLines: 12,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  //  counterText: charLength.toString(),
                                  labelText: 'Description',
                                  hintText:
                                      'Product description in 12 line maximum',
                                  border: OutlineInputBorder(),
                                ),
                                onSaved: (value) {
                                  _productDescription = value;
                                },
                                onChanged: (text) {
                                  // setState(() => charLength -= text.length);
                                }),
                            //    SizedBox(height: 10),
                            //quantity---------------------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  //flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      key: ValueKey('Quantity'),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Quantity is missed';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Quantity',
                                      ),
                                      onSaved: (value) {
                                        _productQuantity = value;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  nfcReadResponse(
      {BuildContext ctx, bool supportsNFC, HomeCubit homeCubit}) async {
    if (!supportsNFC) {
      await defaultAlertDialog(
          title: 'NFC Alert',
          subTitle:
              "To continue, turn on NFC in your device Or scan your items with BarCode",
          context: ctx,
          showSeconedBUTTON: false);
    } else {
      await showDialog(
          context: ctx,
          builder: (context) {
            Stream<NDEFMessage> _stream = NFC.readNDEF(once: true);

            //  _stream = NFC
            //         .readNDEF(
            //             once: true,
            //             throwOnUserCancel: false,
            //             alertMessage: 'readed'
            //             )
            _stream.listen(
              (
                NDEFMessage message,
              ) {
                print("read NDEF message: ${message.records.first}");
                print("read NDEF message: ${message.type}");
                print("read NDEF message: ${message.payload[1]}");
                print("read NDEF message: ${message.messageType}");
                print("read NDEF message: ${message.id}");
                print("read NDEF message: ${message.data}");
                List dataSplited = message.data.split(" ");
                print(dataSplited);
                homeCubit.tagInfo = {
                  'tagId': message.tag.id,
                  'productName': dataSplited[0],
                  'productPrice': int.parse(dataSplited
                      .sublist(1, 2)[0]
                      .toString()
                      .split('L')[0]
                      .toString()),
                  'productFullNameOnTag': message.data,
                };
                homeCubit.tagInformation = TagModel.fromJson(homeCubit.tagInfo);
                //  print('productName : ${tagInfo['productName']}');
                //  print('productPrice : ${tagInfo['productPrice']}');
                print('productName : ${homeCubit.tagInformation.productName}');
                print(
                    'productPrice : ${homeCubit.tagInformation.productPrice}');
                print('TagId : ${homeCubit.tagInformation.tagId.toString()}');
                print(
                    'productFullNameOnTag : ${homeCubit.tagInformation.productFullNameOnTag}');
              },
              onError: (error) {
                // Check error handling guide below
                print("read NDEF message: ${error.toString()}");
                Toast.show('${error.toString()}', ctx,
                    gravity: 1, duration: 4, backgroundColor: Colors.red);
              },
              onDone: () {
                print('done');
                setState(() {
                  _productTagIdController.text = homeCubit.tagInformation.tagId;
                  _productTagIdNumber = homeCubit.tagInformation.tagId;
                });
                //  _stream.pause();  => if   StreamSubscription<NDEFMessage> _stream;
                Navigator.of(context).pop();
              },
            );

            return AlertDialog(
              scrollable: true,
              title: Row(
                children: [
                  Icon(
                    Icons.nfc,
                    color: Colors.green,
                    size: 30,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Scan Your Tag',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                ],
              ),
              actions: [
                //     TextButton(onPressed: () {
                //        //----------------------
                //    Navigator.of(context).pop();
                //  } ,
                // child: Text('Yes' , style: TextStyle(fontWeight: FontWeight.w500 , color: Colors.red),)),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel',
                        style: TextStyle(fontWeight: FontWeight.w500))),
              ],
              content: Column(
                children: [
                  Text(
                    'Please Put your phone on Zenon Tag for this product',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Image(
                    image: AssetImage('assets/images/zenonNfc.png'),
                    height: 230,
                    width: 230, fit: BoxFit.fill,
                    //MediaQuery.of(context).size.width*0.6,fit: BoxFit.fill,
                  ),
                ],
              ),
            );
          });
    }
    // return RaisedButton(
    //     child: Text(_reading ? "Stop reading" : "Start reading"),
    //     onPressed: () {
    //       if (_reading) {
    //         _stream?.cancel();

    //         setState(() {
    //           _reading = false;
    //         });
    //       } else {
    //         setState(() {
    //           _reading = true;
    //           // Start reading using NFC.readNDEF()
    //           });
    //       }
    //     });
  }

  scanBarcode({HomeCubit cubit, BuildContext ctx}) async {
    try {
      await FlutterBarcodeScanner.scanBarcode(
              '#585CE3', 'Cancel', true, ScanMode.BARCODE)
          .then((value) {
        setState(() {
          cubit.scanBarcodeResult = value;
          _productSerialNumberController.text = value;
          _productSerialNumber = value;
        });
      });
    } catch (error) {
      print(error.toString());
      defaultAlertDialog(
          context: ctx,
          showSeconedBUTTON: false,
          title: 'Alert',
          subTitle: '${error.toString()}');
    }
    // print(scanResult);
    //return scanResult;
  }
}

class GradientIcon extends StatelessWidget {
  GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
