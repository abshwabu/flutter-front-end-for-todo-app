// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/Constants/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void  fetchall()async {
    try{
      http.Response response = await http.get(Uri.parse(apikey));
      var data = response.body;
      // data = jsonEncode(data);
      print(data);
    }
    catch(e){
      print(e);
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
      appBar: AppBar(
        title: const Text('Todo app'),
      ),
    );
  }
}