import 'package:bloc/shared/components/components.dart';
import 'package:bloc/shared/components/constants.dart';
import 'package:flutter/material.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListView.separated(itemBuilder: (context,index)=>tasksBuilder(),

     separatorBuilder: (context,index)=>Container(width: double.infinity,height: 1,color: Colors.grey[300]) ,
      itemCount: tasks.length);
}

}