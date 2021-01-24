import 'package:kulina/model/product_response.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  List<ProductResponse> cart = [];
  double totalCartValue = 0;
  int totalQty = 0;

  int get total => cart.length;

  void addProduct(product) {
    print(product);
    int index = cart.indexWhere((i) => i.id == product.id);
    print(index);
    if (index != -1)
      updateProduct(product, product.qty + 1);
    else {
      cart.add(product);
      calculateTotal();
      print('sukses');
      notifyListeners();
    }
  }

  void removeProduct(product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    cart[index].qty = 1;
    cart.removeWhere((item) => item.id == product.id);
    calculateTotal();
    notifyListeners();
  }

  void updateProduct(product, qty) {
    int index = cart.indexWhere((i) => i.id == product.id);
    cart[index].qty = qty;
    if (cart[index].qty == 0) removeProduct(product);

    calculateTotal();
    notifyListeners();
  }

  void clearCart() {
    cart.forEach((f) => f.qty = 1);
    cart = [];
    notifyListeners();
  }

  void calculateTotal() {
    totalCartValue = 0;

    cart.forEach((f) {
      print(f.price);
      print(f.qty);
      totalQty = f.qty;
      totalCartValue += f.price * f.qty;
      print(totalCartValue);
    });
  }
}
