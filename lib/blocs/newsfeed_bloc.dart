import 'package:bloc/bloc.dart';
import 'package:eigital_test/models/product.dart';
import 'package:eigital_test/services/product_service.dart';

class NewsFeedBloc extends Bloc<NewsFeedEvent, List<Product>>{
  ProductService _service = new ProductService();

  NewsFeedBloc() : super([]);

  @override
  Stream<List<Product>> mapEventToState(NewsFeedEvent event) async* {
    // TODO: implement mapEventToState
    switch(event){
      case NewsFeedEvent.GetProducts:
        yield await _service.getProducts();
        break;
      case NewsFeedEvent.GetProductDetails:
        break;
    }
  }

}

enum NewsFeedEvent {GetProducts, GetProductDetails}