import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_outlined)),
        ],
      ),
      body: Column(
        children: [
          CardSwiper(),

          //Listado Horizontal pelis
        ],
      ),
    );
  }
}
