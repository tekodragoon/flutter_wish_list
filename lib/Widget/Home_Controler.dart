import 'package:flutter/material.dart';
import 'EmptyData.dart';
import 'package:flutter_wish_list/Models/Item.dart';
import 'package:flutter_wish_list/Models/DatabaseClient.dart';
import 'ItemDetail.dart';

class HomeController extends StatefulWidget {
  HomeController({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  TextEditingController _addListController;
  String newList;
  List<Item> items;

  @override
  void initState() {
    super.initState();
    _addListController = TextEditingController(text: '');
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            FlatButton(
                onPressed: () => addList(null),
                child: Text(
                  'Add list',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: (items == null || items.length == 0)
            ? EmptyData()
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  Item currentItem = items[i];
                  return ListTile(
                      title: Text(currentItem.name),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          DatabaseClient()
                              .removeItem(currentItem.id, 'item')
                              .then((value) => getData());
                        },
                      ),
                      leading: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => addList(currentItem)),
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext buildContext) {
                            return ItemDetail(currentItem);
                          })));
                },
              ));
  }

  Future<Null> addList(Item item) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext diagCtx) {
          String title = item == null ? 'Add new list' : 'Update list';
          if (item != null) {
            _addListController.text = item.name;
          } else {
            _addListController.text = '';
          }
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: _addListController,
              onChanged: (value) => newList = value,
            ),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(diagCtx),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  )),
              FlatButton(
                  onPressed: () {
                    if (newList != null) {
                      if (item == null) {
                        item = new Item();
                        Map<String, dynamic> map = {'name': newList};
                        item.fromMap(map);
                      } else {
                        item.name = newList;
                      }
                      DatabaseClient().upsertItem(item).then((i) => getData());
                      newList = null;
                    }
                    Navigator.pop(diagCtx);
                  },
                  child: Text(
                    'Valid',
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          );
        });
  }

  getData() {
    DatabaseClient().readAllItem().then((items) {
      setState(() {
        this.items = items;
      });
    });
  }
}
