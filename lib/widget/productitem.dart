import 'package:bookapps/models/books.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class ProductItem extends StatelessWidget {
  final String id, title, price;

  

  ProductItem(this.id, this.title, this.price);

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Books>(context, listen: false);
   
    return ListTile(
      onTap: () {
        //Navigator.pushNamed(context, EditProductPage.route, arguments: id);
      },
      leading: CircleAvatar(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: FittedBox(
            child: Text("\$$price"),
          ),
        ),
      ),
      title: Text("$title"),
      subtitle: Text("Last Edited : "),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          //prov.deleteProduct(id);
        },
      ),
    );
  }
}