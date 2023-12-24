
import 'package:flutter/material.dart';
import 'package:frontend/Constants/colors.dart';

class TodoContainer extends StatelessWidget {
  const TodoContainer({super.key, required this.id, required this.title, required this.description, required this.isDone, required this.onPress});
  final int id;
  final Function onPress;
  final String title;
  final String description;
  final bool isDone;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.all(15),
    child: InkWell(
      onTap: (){
        print('tapped');
      },
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: isDone ? green: red,
          borderRadius: BorderRadius.all(Radius.circular(4),

          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[ Text(title, style:const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                ),
                IconButton(onPressed:() => onPress(), icon: const Icon(Icons.delete),)
                ]
              ),
              Text(description, style:const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 15
              )
              ),
              //
            ],
          ),
        ),
      ),
    )
    );
  }
}