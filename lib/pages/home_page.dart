import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
    return ListView(
      children: [
        ListTile(
          title: Text(
            "Do Laundry",
            style: TextStyle(decoration: TextDecoration.lineThrough),
          ),
          subtitle: Text(DateTime.now().toString()),
          trailing: Icon(Icons.check_box_outlined, color: Colors.red),
        ),
      ],
    );
  }

  Widget _taskView() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.connectionState == ConnectionState.done) {
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
