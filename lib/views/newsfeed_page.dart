import 'package:eigital_test/blocs/newsfeed_bloc.dart';
import 'package:eigital_test/constants/app_labels.dart';
import 'package:eigital_test/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsfeedPage extends StatefulWidget {
  @override
  _NewsfeedPageState createState() => _NewsfeedPageState();
}

class _NewsfeedPageState extends State<NewsfeedPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<NewsFeedBloc>(context).add(NewsFeedEvent.GetProducts);
  }
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NewsFeedBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<NewsFeedBloc, List<Product>>(
          builder: (BuildContext context, List<Product> items){
            if(items.length <= 0){
              return Center(
                child: CircularProgressIndicator(strokeWidth: 2,),
              );
            }
            return _productRow(items, view: ProductView.Grid);
          }
      ),
    );
  }

  Widget _productRow(List<Product> items, {ProductView view = ProductView.Grid}) {
    switch(view){
      case ProductView.List:
        return _listRow(items);
        break;
      default:
        return _gridRow(items);
    }
  }

  Widget _gridRow(List<Product> items) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(items.length, (index){
        Product product = items[index];
        return Column(
          children: [
            Image.network(product.image, height: 100, width: 100,),
            Text(product.title),
          ],
        );
      }
      ),
    );
  }

  Widget _listRow(List<Product> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index){
        Product product = items[index];
        return Column(
          children: [
            Image.network(product.image, height: 100, width: 100,),
            Text(product.title),
          ],
        );
      },
    );
  }
}

enum ProductView {Grid, List}
