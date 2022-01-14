import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wish_list/Models/ItemArticle.dart';
import 'package:flutter_wish_list/Models/DatabaseClient.dart';
import 'package:image_picker/image_picker.dart';

class AddArticle extends StatefulWidget {
  final int id;
  final ItemArticle currentArticle;

  AddArticle(this.id, this.currentArticle);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  String name;
  String magasin;
  String price;
  String image;

  final _picker = ImagePicker();

  TextEditingController _nameController;
  TextEditingController _magasinController;
  TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '');
    _magasinController = TextEditingController(text: '');
    _priceController = TextEditingController(text: '');
    if (widget.currentArticle != null) {
      _nameController.text = widget.currentArticle.name;
      _magasinController.text = widget.currentArticle.magasin;
      _priceController.text = widget.currentArticle.price;
      name = widget.currentArticle.name;
      magasin = widget.currentArticle.magasin ?? null;
      price = widget.currentArticle.price ?? null;
      image = widget.currentArticle.image ?? null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add article'),
        actions: [
          FlatButton(
              onPressed: addArticle,
              child: Text('Valid', style: TextStyle(color: Colors.white)))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Article to add',
                style: TextStyle(
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0)),
            div(),
            Card(
                elevation: 10.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    image == null
                        ? Image.asset(
                            'Assets/Unknown.png',
                            fit: BoxFit.fitHeight,
                          )
                        : Image.file(File(image)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              icon: Icon(Icons.camera_enhance,
                                  size: 40.0, color: Colors.black),
                              onPressed: () => getImage(ImageSource.camera)),
                          IconButton(
                              icon: Icon(Icons.photo_library,
                                  size: 40.0, color: Colors.black),
                              onPressed: () => getImage(ImageSource.gallery)),
                        ]),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        children: [
                          defTextField(TypeTextField.name, 'Enter name'),
                          defTextField(TypeTextField.price, 'Enter price'),
                          defTextField(
                              TypeTextField.magasin, 'Enter magasin name')
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                  ],
                )),
            div(),
          ],
        ),
      ),
    );
  }

  Divider div() {
    return Divider(
        height: 20.0,
        thickness: 2.0,
        color: Colors.black,
        indent: 10.0,
        endIndent: 10.0);
  }

  TextField defTextField(TypeTextField type, String label) {
    return TextField(
        controller: defController(type),
        decoration: InputDecoration(labelText: label),
        onChanged: (String txt) {
          switch (type) {
            case TypeTextField.name:
              name = txt;
              break;
            case TypeTextField.price:
              price = txt;
              break;
            case TypeTextField.magasin:
              magasin = txt;
              break;
          }
        });
  }

  TextEditingController defController(TypeTextField type) {
    switch (type) {
      case TypeTextField.name:
        return _nameController;
      case TypeTextField.magasin:
        return _magasinController;
      case TypeTextField.price:
        return _priceController;
      default:
        return TextEditingController(text: '');
    }
  }

  void addArticle() {
    if (name != null) {
      Map<String, dynamic> map = {'name': name, 'itemId': widget.id};
      if (magasin != null) map['magasin'] = magasin;
      if (price != null) map['price'] = price;
      if (image != null) map['image'] = image;
      if (widget.currentArticle != null) map['id'] = widget.currentArticle.id;
      ItemArticle article = ItemArticle();
      article.fromMap(map);
      DatabaseClient().upsertArticle(article).then((value) {
        magasin = null;
        price = null;
        name = null;
        image = null;
        _nameController = null;
        _magasinController = null;
        _priceController = null;
        Navigator.pop(context);
      });
    }
  }

  Future getImage(ImageSource source) async {
    PickedFile newImage = await _picker.getImage(source: source);
    setState(() {
      image = newImage.path;
    });
  }
}

enum TypeTextField { name, price, magasin }
