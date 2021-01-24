import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:kulina/model/cart_model.dart';

class CartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    print("cek length");
    print(
        ScopedModel.of<CartModel>(context, rebuildOnChange: true).cart.length);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Review Pesanan"),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  "Clear",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => ScopedModel.of<CartModel>(context).clearCart())
          ],
        ),
        body: ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                    .cart
                    .length ==
                0
            ? Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/empty_pic.jpg',
                              width: MediaQuery.of(context).size.width,
                            ),
                            Text(
                              "Keranjangmu masih kosong, nih.",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: 60.0,
                        child: new RawMaterialButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.orange[900],
                          elevation: 0.0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              child: Text(
                                "Pesan Sekarang",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                              )),
                        ))
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Daftar Pesanan",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      FlatButton(
                          child: Text(
                            "Hapus Pesanan",
                            style: TextStyle(color: Colors.grey),
                          ),
                          onPressed: () =>
                              ScopedModel.of<CartModel>(context).clearCart())
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ScopedModel.of<CartModel>(context,
                              rebuildOnChange: true)
                          .total,
                      itemBuilder: (context, index) {
                        return ScopedModelDescendant<CartModel>(
                          builder: (context, child, model) {
                            return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image.network(
                                    model.cart[index].imageUrl,
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(model.cart[index].brandName,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 5.0),
                                        Text(
                                          model.cart[index].brandName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.delete,
                                        size: 25.0,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        NumberFormat.currency(
                                                locale: 'id',
                                                decimalDigits: 0,
                                                symbol: 'Rp')
                                            .format(model.cart[index].qty *
                                                model.cart[index].price),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Row(children: [
                                          IconButton(
                                            icon: Icon(Icons.remove),
                                            onPressed: () {
                                              model.updateProduct(
                                                  model.cart[index],
                                                  model.cart[index].qty - 1);
                                              // model.removeProduct(model.cart[index]);
                                            },
                                          ),
                                          Text(
                                              model.cart[index].qty.toString()),
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              model.updateProduct(
                                                  model.cart[index],
                                                  model.cart[index].qty + 1);
                                              // model.removeProduct(model.cart[index]);
                                            },
                                          ),
                                        ]),
                                      )
                                    ],
                                  ),
                                ));
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60.0,
                      child: new RawMaterialButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.orange[900],
                        elevation: 0.0,
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      ScopedModel.of<CartModel>(context,
                                                  rebuildOnChange: true)
                                              .totalQty
                                              .toString() +
                                          ' item   |   ' +
                                          NumberFormat.currency(
                                                  locale: 'id',
                                                  decimalDigits: 0,
                                                  symbol: 'Rp')
                                              .format(ScopedModel.of<CartModel>(
                                                      context,
                                                      rebuildOnChange: true)
                                                  .totalCartValue) +
                                          "",
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(
                                      'Termasuk Ongkos Kirim',
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.white),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'CHECKOUT',
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 25.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ))
                ])));
  }
}
