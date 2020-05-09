import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(
      home: TodoList(),
      debugShowCheckedModeBanner: false,
    ));

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> tasks = new List<String>();

  // @override
  // void initState() {
  //   super.initState();
  //   storeStringList(tasks);
  //   getStringList().then((List<String> data) {
  //     setState(() {
  //       tasks = data;
  //     });
  //   });
  //  // _buildTasks(context);
  // }

  void storeStringList(List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("tasks", list);
  }

  Future<List<String>> getStringList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("tasks");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        title: Text('Todo - List',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: _buildTasks(context),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Task',
        onPressed: _pushAddTodoScreen,
        child: Icon(Icons.add),
        backgroundColor: Colors.amber[300],
      ),
    );
  }

  Widget _buildTasks(BuildContext context) {
    //List<String> list = new List<String>();
    getStringList().then((List<String> data) {
      setState(() {
        tasks = data;
      });
    });
    return ListView.builder(itemBuilder: (context, i) {
      if (tasks != null) {
        if (i < tasks.length) {
          return _buildTaskItems(tasks[i]);
        }
      }
      return Text('');
    });
  }

  void _addTodo(String task) {
    setState(() {
      tasks.add(task);
      storeStringList(tasks);
    });
    //storeStringList(tasks);
  }

  void _removeTodo(String task) {
    // Only add the task if the user actually entered something
    if (tasks.length > 0) {
      setState(() {
        tasks.remove(task);
        storeStringList(tasks);
      });
     // storeStringList(tasks);
    }
  }

  Widget _buildTaskItems(String task) {
    return Center(
      child: Card(
        color: Colors.amber[100],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.5)),
        child: Column(children: <Widget>[
          ListTile(
            title: Text(
              task,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red[300],
              onPressed: () {
                _removeTodo(task);
              },
            ),
          ),
        ]),
      ),
    );
  }

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
        // MaterialPageRoute will automatically animate the screen entry, as well
        // as adding a back button to close it
        MaterialPageRoute(builder: (context) {
      return Scaffold(
          backgroundColor: Colors.amber[200],
          appBar: AppBar(
              title: Text('Add a new task'), backgroundColor: Colors.amber),
          body: TextField(
            style: TextStyle(fontSize: 22.0, color: Colors.grey[900]),
            autofocus: true,
            onSubmitted: (val) {
              _addTodo(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: InputDecoration(
                hintText: 'Enter your task today',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }
}
