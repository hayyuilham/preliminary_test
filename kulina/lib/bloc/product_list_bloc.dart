import 'dart:async';

import 'package:kulina/helper/api_response.dart';
import 'package:kulina/model/product_response.dart';
import 'package:kulina/repository/product_list_repository.dart';

class ProductBloc {
  ProductRepository _productRepository;

  StreamController _productListController;

  StreamSink<ApiResponse<List<ProductResponse>>> get productListSink =>
      _productListController.sink;

  Stream<ApiResponse<List<ProductResponse>>> get productListStream =>
      _productListController.stream;

  ProductBloc() {
    _productListController =
        StreamController<ApiResponse<List<ProductResponse>>>();
    _productRepository = ProductRepository();
    fetchProductList();
  }

  fetchProductList() async {
    productListSink.add(ApiResponse.loading('Fetching Food Available'));
    try {
      List<ProductResponse> food = await _productRepository.fetchProductList();
      productListSink.add(ApiResponse.completed(food));
    } catch (e) {
      productListSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _productListController?.close();
  }
}
