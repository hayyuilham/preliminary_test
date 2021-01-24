import 'package:kulina/model/product_response.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  Future<List<ProductResponse>> fetchProductList() async {
    final response = await http
        .get("https://kulina-recruitment.herokuapp.com/products?_page&_limit");
    return productResponseFromJson(response.body);
  }
}
