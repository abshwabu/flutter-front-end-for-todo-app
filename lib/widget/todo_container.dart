
import 'package:flutter/material.dart';

class TodoContainer extends StatelessWidget {
  const TodoContainer({super.key, required this.id, required this.title, required this.description, required this.isDone});
  final int id;
  final String title;
  final String description;
  final bool isDone;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.all(15),
    child: Container(
      width: double.infinity,
      height: 160,
      decoration:const BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.all(Radius.circular(4),
        
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style:const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),),
            Text(description, style:const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 15
            )
            )
          ],
        ),
      ),
    )
    );
  }
}