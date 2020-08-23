import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recipeapp/Pages/loginScreen.dart';
import 'package:recipeapp/models/db.dart';
import 'package:uuid/uuid.dart';


class addproduct extends StatefulWidget {


 final String addid;
  const addproduct({ this.addid, });



  @override
  _addproductState createState() => _addproductState();
}

class _addproductState extends State<addproduct> {
  static String ImageUrl;
  TextEditingController TitleController = TextEditingController();
  TextEditingController ImageController = TextEditingController(text: ImageUrl);
  TextEditingController VideoController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey();



  String Title;
  String Picture;
  String VideoUrl;
  String Description;
  String _currentTitle;

  @override
  Widget build(BuildContext context) {
    ProductService _ProductService = ProductService();
    return Scaffold(
      body: Form(
        key: _formkey,
        child: ListView(
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(top: 140,right: 50,left: 50),
              child: TextFormField(
                controller: TitleController,
                // ignore: missing_return
                validator: (value){
                  if(value.isEmpty){
                    return 'Title cant be empty';
                  }
                },
                onChanged: (value) => setState(() => _currentTitle = value),

                decoration: InputDecoration(
              hintText: 'Entre Title of product',
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30))
          ),
          ),
          ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50,left: 50),
              child: Builder(

                builder: (context) => FlatButton(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                    onPressed: () => uploadImage(),

                    child: Text('Upload Image'),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 300,
              width: 300,
              child: Column(
                children: <Widget>[
                  (ImageUrl != null) ? Expanded(
                    child: CachedNetworkImage(
                      imageUrl: ImageUrl ,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),),): Container(
                    height: 300,
                    width: 300,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50,left: 50),
              child: TextFormField(
                controller: VideoController,
                // ignore: missing_return
                validator: (value){
                  if(value.isEmpty){
                    return 'Video cant be empty';
                  }
                },
                decoration: InputDecoration(
                    hintText: 'Entre UrlVideo ',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30))
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: DescriptionController,
              // ignore: missing_return
              validator: (value){
                if(value.isEmpty){
                  return 'Description cant be empty';
                }
              },
              decoration: InputDecoration(
                  hintText: 'Entre Description ',
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: (){
                    _ProductService.createproduct(

                      TitleController.text,
                      ImageController.text,
                      VideoController.text,
                      DescriptionController.text,

                      widget.addid,
                    );
                    print(TitleController.text);
                    TitleController.clear();
                    ImageController.clear();
                    VideoController.clear();
                    DescriptionController.clear();

                  },
                  child: Text('Confirm '),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                SizedBox(
                  width: 30,
                ),
                RaisedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel '),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ],

            ),




          ],
        ),
      ),
    );
  }



  File _image;
  Future uploadImage() async{
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    await Permission.photos.request();
    PickedFile image;

    var permissioStatus = await Permission.photos.status;
    if(permissioStatus.isGranted){

     final  image =  await _picker.getImage(source: ImageSource.gallery);

      setState(() {
        _image = File(image.path);
      });

      if(image != null){
        var uuid = Uuid().v4();

        var snapshot = await _storage.ref().child('${widget.addid}/$uuid' ).putFile(_image).onComplete.catchError((onError){
          print(onError);
          return true;
        });
        var downloadurl = await snapshot.ref.getDownloadURL();

        setState(() {

          ImageUrl = downloadurl;
        });
      }else {
        print('no path received');
      }




    }else{
      print('grant permission and try again');
    }

  }
}




