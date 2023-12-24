// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/Models/todo.dart';
import 'package:frontend/widget/appbar.dart';
import 'package:frontend/widget/todo_container.dart';
import 'package:gap/gap.dart';
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

  void deleteTodo(var id) async {
    try {
      http.Response response = await http.delete(Uri.parse('$apikey/' + id));
      print('deleted');
      setState(() {
        myTodo = [];
      });
      fetchAll();
    } catch (e) {
      print(e);
    }
  }

  void _postTask({String title='', String description=''}) async {
    http.Response response = await http.post(Uri.parse(apikey),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,dynamic>{
        "title":title,
        'description':description,
        'is_done':false
      })
    );

    if(response.statusCode == 201){
      setState(() {
        myTodo = [];
        fetchAll();
      });
    }
    else{
      print('something is wrong');
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
      backgroundColor: background,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: PieChart(dataMap: {
                    'Done': done.toDouble(),
                    'Incomplete': (myTodo.length - done).toDouble()
                  }),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: myTodo
                          .map((e) => TodoContainer(
                                onPress: () => deleteTodo(e.id.toString()),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String title='';
          String description='';
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height / 2,
                color: Colors.white,
                child: Center(
                    child: Column(
                  children: [
                    const Text(
                      'Add your task',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(15),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.task),
                        hintText: 'Enter the task',
                        labelText: 'Task',
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                    ),
                    Gap(10),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.description),
                        hintText: 'Describe your task',
                        labelText: 'Description',
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                    ),
                    ElevatedButton(
                        onPressed: ()=>_postTask(
                          title: title,
                          description: description
                        ),
                        child: Text('Add')
                    )
                  ],
                )),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
