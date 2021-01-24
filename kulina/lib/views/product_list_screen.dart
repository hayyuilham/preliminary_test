import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kulina/bloc/product_list_bloc.dart';
import 'package:kulina/helper/api_response.dart';
import 'package:kulina/model/cart_model.dart';
import 'package:kulina/model/product_response.dart';
import 'package:kulina/utils/sabt.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:intl/intl.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool changeButton = false;
  ProductBloc _bloc;
  DateTime startDate = DateTime.now(); //.subtract(Duration(days: 2));
  DateTime endDate = DateTime.now().add(Duration(days: 56));
  DateTime selectedDate = DateTime.now().subtract(Duration(days: 2));
  onSelect(data) {
    print("Selected Date -> $data");
  }

  onWeekSelect(data) {
    print("Selected week starting at -> $data");
  }

  _monthNameWidget(yearName) {
    return Positioned(
        top: 100,
        child: Text(yearName,
            style: TextStyle(
                fontSize: 7,
                color: Colors.white,
                fontStyle: FontStyle.italic)));
  }

  List<DateTime> markedDates = [
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now().subtract(Duration(days: 2)),
    DateTime.now().add(Duration(days: 4))
  ];

  dateTileBuilder(
      date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? Colors.black26 : Colors.black87;
    TextStyle normalStyle =
        TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(
        fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black87);
    TextStyle dayNameStyle = TextStyle(fontSize: 5, color: fontColor);
    List<Widget> _children = [
      Text(dayName, style: dayNameStyle),
      Text(date.day.toString(),
          style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate ? Colors.transparent : Colors.yellow,
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        children: _children,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc = ProductBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                primary: true,
                pinned: true,
                title: SABT(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Alamat Pengantaran',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 10,
                                  fontFamily: 'Calibri'),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.arrow_drop_down_rounded,
                              color: Colors.grey[600],
                              size: 25,
                            )
                          ],
                        ),
                        GestureDetector(
                          child: Text(
                            'Kulina',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Calibri',
                                fontSize: 15.0),
                          ),
                          onTap: () {
                            print("tapped subtitle");
                          },
                        ),
                      ]),
                ),
                expandedHeight: 150.0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: EdgeInsetsDirectional.only(
                      start: 16.0, bottom: 16.0, end: 16.0),
                  title: CalendarStrip(
                    weekStartsOnSunday: false,
                    addSwipeGesture: true,
                    startDate: startDate,
                    endDate: endDate,
                    onDateSelected: onSelect,
                    onWeekSelected: onWeekSelect,
                    dateTileBuilder: dateTileBuilder,
                    iconColor: Colors.black87,
                    monthNameWidget: _monthNameWidget,
                    markedDates: markedDates,
                    containerHeight: 40.0,
                    containerDecoration: BoxDecoration(color: Colors.grey[100]),
                  ),
                  background: Container(
                    color: Colors.white,
                  ),
                ),
              ),
              StreamBuilder<ApiResponse<List<ProductResponse>>>(
                stream: _bloc.productListStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return Loading(loadingMessage: snapshot.data.message);
                        break;
                      case Status.COMPLETED:
                        return Builder(
                          builder: (context) {
                            return _productsList(foodList: snapshot.data.data);
                          },
                        );

                        break;
                      case Status.ERROR:
                        return Error(
                          errorMessage: snapshot.data.message,
                          onRetryPressed: () => _bloc.fetchProductList(),
                        );
                        break;
                    }
                  }
                  return SliverToBoxAdapter(
                    child: Container(),
                  );
                },
              ),
            ],
          ),
          (ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                      .totalCartValue) !=
                  0
              ? new Positioned(
                  bottom: 10.0,
                  left: 10.0,
                  right: 10.0,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60.0,
                      child: new RawMaterialButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.orange[900],
                        elevation: 0.0,
                        onPressed: () => Navigator.pushNamed(context, '/cart'),
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
                                Icon(
                                  Icons.shopping_cart,
                                  size: 25.0,
                                  color: Colors.white,
                                ),
                              ]),
                        ),
                      )))
              : Positioned(
                  child: Container(),
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Widget _productsList({List<ProductResponse> foodList}) {
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.5),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ScopedModelDescendant<CartModel>(
                builder: (context, child, model) {
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(
                        foodList[index].imageUrl.isEmpty
                            ? CircularProgressIndicator()
                            : foodList[index].imageUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _rating(foodList[index].rating),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            foodList[index].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            "by ${foodList[index].brandName} - ${foodList[index].name}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.grey[400]),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            foodList[index].brandName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10.0, color: Colors.grey[300]),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                NumberFormat.currency(
                                        locale: 'id',
                                        decimalDigits: 0,
                                        symbol: 'Rp')
                                    .format(foodList[index].price),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                "termasuk ongkir",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.grey[400]),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    foodList[index].qty == null
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OutlineButton(
                                child: Text(
                                  "Tambah ke Keranjang",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                onPressed: () {
                                  foodList[index].qty = 1;
                                  model.addProduct(foodList[index]);
                                }))
                        : ScopedModel.of<CartModel>(context,
                                        rebuildOnChange: true)
                                    .cart
                                    .length ==
                                0
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: OutlineButton(
                                    child: Text(
                                      "Tambah ke Keranjang",
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                    onPressed: () {
                                      foodList[index].qty = 1;
                                      model.addProduct(foodList[index]);
                                    }))
                            : foodList[index].imageUrl.isEmpty
                                ? CircularProgressIndicator()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () {
                                            model.updateProduct(
                                                model.cart[index],
                                                model.cart[index].qty - 1);
                                          },
                                        ),
                                        Text('1'),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            model.updateProduct(
                                                model.cart[index],
                                                model.cart[index].qty + 1);
                                          },
                                        ),
                                      ])
                  ],
                ),
              );
            });
          },
          childCount: foodList.length,
        ));
  }

  _rating(double rating) {
    if (rating < 3.0) {
      return Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.green[400],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            'BARU',
            style: TextStyle(fontSize: 10.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        width: 40.0,
      );
    } else {
      return Row(
        children: <Widget>[
          Text("${rating.toDouble().toStringAsFixed(1)}"),
          SizedBox(width: 10.0),
          SmoothStarRating(
            rating: rating,
            color: Color(0xfff4a548),
            borderColor: Color(0xfff4a548),
            size: 12.0,
            starCount: 5,
            allowHalfRating: true,
            isReadOnly: true,
          )
        ],
      );
    }
  }
}

class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            RaisedButton(
              color: Colors.orange,
              child: Text('Retry', style: TextStyle(color: Colors.white)),
              onPressed: onRetryPressed,
            )
          ],
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              loadingMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orange[900],
                fontSize: 24,
              ),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[900]),
            ),
          ],
        ),
      ),
    );
  }
}
