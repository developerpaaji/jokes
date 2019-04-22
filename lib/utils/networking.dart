import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jokes/models/joke.dart';

Future<List<Joke>> getJokes(String category)async{
  http.Response response=await http.get("https://official-joke-api.appspot.com/jokes/$category/ten");
  List json=jsonDecode(response.body);
  print(json.runtimeType);
  return List<Joke>.from(json.map((item)=>Joke.fromJson(item)).toList()).toList();
}