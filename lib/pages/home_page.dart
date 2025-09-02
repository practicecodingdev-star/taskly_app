import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly_app/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double deviceHeight, deviceWidth;
  String? _taskContent;
  Box? _box;
  _HomePageState();
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        toolbarHeight: deviceHeight * 0.15,
        title: const Text(
          "Taskly!",
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: _taskView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _taskList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext _context, int _index) {
        Task task = Task.fromMap(tasks[_index]);
        return ListTile(
          title: Text(
            task.content,
            style: TextStyle(
              decoration: task.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(task.timestamp.toString()),
          trailing: Icon(
            task.done
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank_outlined,
            color: Colors.red,
          ),
          onTap: () {
            task.done = !task.done;
            _box!.putAt(_index, task.toMap());
            setState(() {});
          },
          onLongPress: () {
            _box!.deleteAt(_index);
            setState(() {
              
            });
          },
        );
      },
    );
  }

  Widget _taskView() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          _box = _snapshot.data;
          return _taskList();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displayTaskPopup,
      child: const Icon(Icons.add_outlined),
    );
  }

  void _displayTaskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: const Text("Add New Task!"),
          content: TextField(
            onSubmitted: (value) {
              if (_taskContent != null) {
                Task task = Task(
                  content: _taskContent!,
                  timestamp: DateTime.now(),
                  done: false,
                );
                _box!.add(task.toMap());
              }
              setState(() {
                _taskContent = null;
              });
              Navigator.of(_context).pop();
            },
            onChanged: (value) {
              setState(() {
                _taskContent = value;
              });
            },
          ),
        );
      },
    );
  }
}
