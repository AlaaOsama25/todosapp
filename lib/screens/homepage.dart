import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:todos_app/model/todos.dart';
import 'editscreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final todosReference = FirebaseDatabase.instance.reference().child('todos');

class _MyHomePageState extends State<MyHomePage> {

  late List<Todos> items;
  late StreamSubscription<Event> _OntodoAddedSubscribtion;
  late StreamSubscription<Event> _OntodoUpdatedSubscribtion;


  @override
  void initState() {
    super.initState();
    items = [];
    _OntodoAddedSubscribtion = todosReference.onChildAdded.listen(_OnAddedTodo);
    _OntodoUpdatedSubscribtion = todosReference.onChildChanged.listen(_OnUpdatedTodo);


  }
  @override
  void dispose() {
    super.dispose();
    _OntodoAddedSubscribtion.cancel();
    _OntodoUpdatedSubscribtion.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Stack(
          children: <Widget> [
            Container(
              height: double.infinity,
              child: Image.asset('images/image.png'),
            ),
             Positioned(
              top: 80,
                left: 20,
                child: Column(
                  children:  [
                    const Text(
                      'Todos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Created Tasks ${items.length}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),

                  ],
                )
            ),
            DraggableScrollableSheet(
                maxChildSize: 0.80,
                minChildSize: 0.15,
                initialChildSize: 0.15,
                builder: (BuildContext context , ScrollController scrollController) {
                  return Stack(
                    overflow: Overflow.visible,
                    children: [
                      Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                      ),
                      child: ListView.builder(
                          controller: scrollController,
                          itemCount: items.length,
                          itemBuilder: (BuildContext context , index){
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ListTile(
                                title: Text(items[index].title.toString(),
                                  style: const TextStyle(
                                   fontSize: 17,
                                    fontWeight: FontWeight.w700
                                ),),
                                subtitle: Text(items[index].subtitle.toString()),
                                trailing:  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline,
                                        color: Colors.deepPurple),
                                  onPressed: () {
                                      _DeleteTodo(context, items[index], index);
                                  },
                                ),
                                onTap: (){
                                  _UpdateTodo(context,items[index]);
                                },
                              ),
                            );
                          }
                      ),

                    ),
                      Positioned(
                          top: -30,
                          right:30,
                          child: FloatingActionButton(
                            child: const Icon(Icons.add,size: 30,),
                            onPressed: (){
                              _createNewTodo(context);
                            },
                            backgroundColor: Colors.greenAccent,
                          )
                      ),
                  ]
                  );
                }
            ),

          ],
        ),
      )
    );
  }

  void _createNewTodo(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyTodoScreen(todo : Todos(null,'',''))),
    );
  }

  void _OnAddedTodo(Event event) {
   setState(() {
     items.add(Todos.fromSnapshot(event.snapshot));

   });
  }

  void _UpdateTodo(BuildContext context , Todos todo)async{
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyTodoScreen(todo : todo)),
    );
  }

  void _OnUpdatedTodo(Event event){
    var oldtodo = items.singleWhere((todo) => todo.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldtodo)]=  Todos.fromSnapshot(event.snapshot);
    });
  }

  void _DeleteTodo(BuildContext context , Todos todo , int index) async {
    await todosReference.child(todo.id.toString()).remove().then((value) {
      setState(() {
        items.removeAt(index);
      });
    });
  }
}
