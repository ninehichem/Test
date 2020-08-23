

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService {





  void createproduct(String title,String picture,String videourl,String description,String id) {

    Firestore.instance.collection('Category').document(id).collection('Food').document().setData(
        {
          'Title': title,
          'picture':picture,
          'Description':description,
          'videoUrl':videourl,
    });
  }

  void updateproduct(String title,String picture,String videourl,String description,String id,docid) {

    Firestore.instance.collection('Category').document(id).collection('Food').document(docid).updateData(
        {
          'Title': title,
          'picture':picture,
          'Description':description,
          'videoUrl':videourl,
        }
        );
  }

//----------------------------------____----------------------------------------------------------------------
  void updatelastproduct(String title,String picture,String videourl,String description,String id) {

    Firestore.instance.collection('Last Food').document(id).updateData(
        {
          'Title': title,
          'picture':picture,
          'Description':description,
          'videoUrl':videourl,
        }
    );
  }

  void createlastproduct(String title,String picture,String videourl,String description) {

    Firestore.instance.collection('Last Food').document().setData(
        {
          'Title': title,
          'picture':picture,
          'Description':description,
          'videoUrl':videourl,
        });
  }






}