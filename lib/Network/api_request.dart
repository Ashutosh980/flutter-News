import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tamasha/Const/const.dart';

import 'package:tamasha/Model/news.dart';


News parseNews(String responseBody){
  var I=json.decode(responseBody);
  var news=News.fromJson(I);
  return news;
}

Future<News>fetchNewsByCategory(String category)async{
  final url = Uri.parse( '$mainUrl$topHeadlines?language=en&category=$category&apikey=$apikey');
  http.Response response = await http.get(url);
  //final response=await http.get('$mainUrl$topHeadlines?language=en&category=$category&apikey=$apikey');
  if (response.statusCode == 200)
   return compute(parseNews,response.body);
 else if (response.statusCode==400)
   throw Exception('not found 404');

  else throw Exception('cannot get News');
}



