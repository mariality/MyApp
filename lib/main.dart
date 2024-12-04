import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
/*I made this app without using any tutorials, 
but I did use ChatGPT for assistance. 
I didn't create this entirely on my own. 
Also, I’m not sure why, but this app only works on Chrome. 
When I try using an emulator, it doesn’t work.*/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Map<String, dynamic>> tasks = [];
  final TextEditingController taskController = TextEditingController();
  bool isTasksDone = false; // Default status for new tasks

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks when app starts
  }

  // Load tasks from shared_preferences
  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTasks = prefs.getString('tasks');
    if (savedTasks != null) {
      setState(() {
        tasks.addAll(List<Map<String, dynamic>>.from(jsonDecode(savedTasks)));
      });
    }
  }

  // Save tasks to shared_Preferences
  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', jsonEncode(tasks));
  }

  void _addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add({'task': taskController.text, 'done': isTasksDone});
      });
      taskController.clear();
      isTasksDone = false; // Default checkbox value

      taskController.clear();
      isTasksDone = false;
      _saveTasks(); // Save tasks after adding
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _toggledone(int index) {
    setState(() {
      tasks[index]['done'] = !tasks[index]['done'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //TextField for adding tasks
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: 'Enter task',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // Button to add task
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Add task'),
            ),
            //List of tasks
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Checkbox(
                        value: tasks[index]['done'],
                        onChanged: (value) {
                          _toggledone(index);
                        },
                      ),
                      title: Text(
                        tasks[index]['task'],
                        style: TextStyle(
                          decoration: tasks[index]['done']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete,
                            color: const Color.fromARGB(255, 201, 22, 9)),
                        onPressed: () {
                          _deleteTask(index);
                        },
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
