// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Models/todo.dart';
import 'package:frontend/widget/appbar.dart';
import 'package:frontend/widget/todo_container.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/Constants/api.dart';
import 'package:pie_chart/pie_chart.dart';
// ... (imports)

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  num done = 0;
  bool isLoading = true;
  List<Todo> myTodo = [];

  void fetchAll() async {
    try {
      http.Response response = await http.get(Uri.parse(apikey));
      var raw = response.body;
      var data = json.decode(raw);
      data.forEach((todo) {
        Todo t = Todo(
          id: todo['id'],
          title: todo['title'],
          description: todo['description'],
          isDone: todo['is_done'],
        );
        if (todo['is_done']) {
          done += 1;
        }
        myTodo.add(t);
      });
    } catch (e) {
      print('Your error is $e');
      // Handle the error, show a SnackBar, or display an error message
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  void deleteTodo(var id) async{
    try{
      http.Response response = await http.delete(Uri.parse('$apikey/'+ id));
      fetchAll();
    }
    catch(e){
      print(e);
    }

  }

  @override
  void initState() {
    fetchAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      backgroundColor: const Color(0xff001133),
      body: Column(
        children: [
          Expanded(
            child: PieChart(dataMap: {
              'Done': done.toDouble(),
              'Incomplete': (myTodo.length - done).toDouble()
            }),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: myTodo
                    .map((e) => TodoContainer(
                  id: e.id,
                  title: e.title,
                  description: e.description,
                  isDone: e.isDone,
                ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
