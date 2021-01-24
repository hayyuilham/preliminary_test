import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:kulina/views/product_list_screen.dart';
import 'package:kulina/views/cart_screen.dart';
import 'package:kulina/model/cart_model.dart';

void main() {
  runApp(MyApp(
    model: CartModel(),
  ));
}

class MyApp extends StatelessWidget {
  final CartModel model;

  const MyApp({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScopedModel<CartModel>(
      model: model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Calibri', primaryColor: Colors.white),
        home: ProductListScreen(),
        routes: {'/cart': (context) => CartScreen()},
      ),
    );
  }
}
