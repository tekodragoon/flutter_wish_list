class ItemArticle {
  int id;
  String name;
  int itemId;
  var price;
  String magasin;
  String image;

  ItemArticle();

  fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.itemId = map['itemId'];
    this.price = map['price'];
    this.magasin = map['magasin'];
    this.image = map['image'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': this.name,
      'itemId': this.itemId,
      'price': this.price,
      'magasin': this.magasin,
      'image': this.image
    };
    if (this.id != null) {
      map['id'] = this.id;
    }
    return map;
  }
}
