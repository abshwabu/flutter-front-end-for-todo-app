// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Models/todo.dart';
import 'package:frontend/widget/appbar.dart';
import 'package:frontend/widget/todo_container.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/Constants/api.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  num done = 0;
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
        if (todo['is_done']){
          done+= 1;
        }
        myTodo.add(t);
        setState(() {
          isLoading = false;
          
        });
      });
    }
    catch(e){
      // ignore: avoid_print
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
      body: isLoading?Center(child: CircularProgressIndicator()):Column(
        children: [
          PieChart(dataMap: {
            'Done':done.toDouble(),
            'Incomplete': (myTodo.length-done).toDouble()
          }),
          ListView(
            children: myTodo.map((e) => TodoContainer(id: e.id, title: e.title, description: e.description, isDone: e.isDone)).toList(),
          ),
        ],
      ),
    );
  }
}