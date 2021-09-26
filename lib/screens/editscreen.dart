import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todos_app/model/todos.dart';
class MyTodoScreen extends StatefulWidget {
  const MyTodoScreen({Key? key,required this.todo,}) : super(key: key);
  final Todos todo;


  @override
  _MyTodoScreenState createState() => _MyTodoScreenState();
}
final todosReference = FirebaseDatabase.instance.reference().child('todos');

class _MyTodoScreenState extends State<MyTodoScreen> {

 TextEditingController _titleController = TextEditingController();
 TextEditingController _subtitleController = TextEditingController();

 @override
 void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _subtitleController = TextEditingController(text: widget.todo.subtitle);

 }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: (widget.todo.id == null)? Text('Add New Task!') : Text('Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30,),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                )
              ),

            ),
            SizedBox(height: 30,),
            TextField(
              controller: _subtitleController,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  hintText: 'SubTitle',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
              ),

            ),
            SizedBox(height: 40,),
            ElevatedButton(
                onPressed: () {
                  if (widget.todo.id == null) {
                    todosReference.push().set(
                        {
                          'title': _titleController.text.toUpperCase(),
                          'subtitle': _subtitleController.text
                        }).then((_) {
                      Navigator.pop(context);
                    });
                  }
                  else {
                    todosReference.child(widget.todo.id.toString()).set(
                        {
                          'title': _titleController.text.toUpperCase(),
                          'subtitle': _subtitleController.text
                        }).then((_) {
                      Navigator.pop(context);
                    });
                  }
                },
                child: (widget.todo.id == null)? Text('Add') : Text('UPDATE'),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(150, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )
                ),


            ),

          ],
        ),
      ),
    );
  }
}
