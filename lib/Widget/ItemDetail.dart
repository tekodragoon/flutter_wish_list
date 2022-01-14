import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wish_list/Models/DatabaseClient.dart';
import 'package:flutter_wish_list/Models/Item.dart';
import 'package:flutter_wish_list/Models/ItemArticle.dart';
import 'package:flutter_wish_list/Widget/AddArticle.dart';
import 'package:flutter_wish_list/Widget/EmptyData.dart';

class ItemDetail extends StatefulWidget {
  final Item item;

  ItemDetail(this.item);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  List<ItemArticle> articles;

  @override
  void initState() {
    super.initState();
    updateArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: [
          FlatButton(
              onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext buildContext) {
                    return AddArticle(widget.item.id, null);
                  })).then((value) => updateArticles()),
              child: Text('Add article', style: TextStyle(color: Colors.white)))
        ],
      ),
      body: articles == null || articles.length == 0
          ? EmptyData()
          : GridView.builder(
              itemCount: articles.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, i) {
                ItemArticle currentArticle = articles[i];
                return InkWell(
                  child: Card(
                    elevation: 10.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(currentArticle.name),
                            IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => DatabaseClient()
                                    .removeArticle(currentArticle)
                                    .then((value) => updateArticles()))
                          ],
                        ),
                        Container(
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: currentArticle.image == null
                                ? Image.asset('Assets/Unknown.png',
                                    fit: BoxFit.fitHeight)
                                : Image.file(File(currentArticle.image))),
                        Text(currentArticle.price == null
                            ? 'No price specified'
                            : 'price: ${currentArticle.price}'),
                        Text(currentArticle.magasin == null
                            ? 'No magasin specified'
                            : 'magasin: ${currentArticle.magasin}'),
                      ],
                    ),
                  ),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext buildContext) {
                    return AddArticle(widget.item.id, currentArticle);
                  })).then((value) => updateArticles()),
                );
              }),
    );
  }

  void updateArticles() {
    DatabaseClient().readAllArticle(widget.item.id).then((value) {
      setState(() {
        articles = value;
      });
    });
  }
}
