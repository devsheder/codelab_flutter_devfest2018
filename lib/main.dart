import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'galaxy.dart';

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Galaxy',
      home: new Galaxies(),
    );
  }
}

class GalaxiesState extends State<Galaxies> {
  List<Galaxy> _galaxies = [];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Flutter Galaxy'),
      ),
      body: _buildGalaxies(),
    );
  }

  Widget _buildGalaxies() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _galaxies.length * 2,
        itemBuilder: (BuildContext _context, int i) {
          // Add a one-pixel-high divider on odd row
          if (i.isOdd) return new Divider();
          // Else build a galaxy row
          final int index = i ~/ 2;
          return _buildRow(_galaxies[index]);
        }
    );
  }

  Widget _buildRow(Galaxy galaxy) {
    return new ListTile(
      title: new Text(
        galaxy.title,
        style: _biggerFont,
      ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (_galaxies.isEmpty) {
      await _retrieveLocalGalaxies();
    }
  }

  Future<void> _retrieveLocalGalaxies() async {
    final json =
    DefaultAssetBundle.of(context).loadString('assets/data/galaxies.json');
    final data = JsonDecoder().convert(await json);
    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }
    var collection = data['collection'];
    if (collection is! Map) {
      throw ('Collection is not a Map');
    }
    var items = collection['items'];
    List<Galaxy> galaxies = [];

    for (var jsonMap in items) {
      var links = jsonMap['links'][0];
      var previewHref = links['href'];
      var data = jsonMap['data'][0];
      var title = data['title'];
      var id = data['nasa_id'];
      var description = data['description'];
      var galaxy = new Galaxy(id: id,title: title, previewHref: previewHref, description: description);
      galaxies.add(galaxy);
    }

    setState(() {
      _galaxies.clear();
      _galaxies.addAll(galaxies);
    });
  }
}
}

class Galaxies extends StatefulWidget {
  @override
  GalaxiesState createState() => new GalaxiesState();
}


void main() {
  runApp(new MyAppBar());
}