// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Models/todo.dart';
import 'package:frontend/widget/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/Constants/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<Todo> myTodo=[];
  void  fetchall()async {
    try{
      http.Response response = await http.get(Uri.parse(apikey));
      var raw = response.body;
      var data = json.decode(raw);
      data.forEach((todo){
        Todo t = Todo(
          id: todo['id'],
          title: todo['title'],
          description: todo['description'],
          isDone: todo['is_done'],

        );
        myTodo.add(t);
        setState(() {
          isLoading = false;
          
        });
      });
      print(myTodo.length);
    }
    catch(e){
      print('your error is$e');
    }
  }
  @override
  void initState() {
    fetchall();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      backgroundColor:const Color(0xff001133),
    );
  }
}