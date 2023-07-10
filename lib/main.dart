import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'recipe.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late List<Recipe> recipes;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final response = loadString('load_json/recipes.json'));
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final recipesJson = jsonBody['recipes'] as List<dynamic>;
      setState(() {
        recipes = recipesJson.map((json) => Recipe.fromJson(json)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (recipes == null) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Recipes'),
        ),
        body: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return ListTile(
              title: Text(recipe.title),
              subtitle: Text(recipe.description),
            );
          },
        ),
      );
    }
  }
}
