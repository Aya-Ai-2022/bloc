import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bloc/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:bloc/modules/done_tasks/done_tasks_screen.dart';
import 'package:bloc/modules/new_tasks/new_tasks_screen.dart';
import 'package:bloc/shared/components/components.dart';
import 'package:bloc/shared/components/constants.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  Database? database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
        ),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDatabase(
                title: titleController.text,
                date: dateController.text,
                time: timeController.text,
              ).then((value) {
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });
            }
          } else {
            scaffoldKey.currentState!.showBottomSheet(
              (context) => Container(
                color: Colors.white,
                padding: const EdgeInsets.all(
                  20.0,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  defaultFormField(
  controller: titleController,
  type: TextInputType.text,
  validate: (String? value) {
    if (value == null || value.isEmpty) {
      return 'Title must not be empty';
    }
    return ''; // Return null if validation passes
  },
  label: 'Task Title',
  prefix: Icons.title,


                     
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        controller: timeController,
                        type: TextInputType.datetime,
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            timeController.text =
                                value!.format(context).toString();
                            print(value.format(context));
                          });
                        },
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'time must not be empty';
                          }
                          return '';
                        },
                        label: 'Task Time',
                        prefix: Icons.watch_later_outlined,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        controller: dateController,
                        type: TextInputType.datetime,
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2025-05-03'),
                          ).then((value) {
                            dateController.text =
                                DateFormat.yMMMd().format(value!);
                          });
                        },
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'date must not be empty';
                          }
                          return '';
                        },
                        label: 'Task Date',
                        prefix: Icons.calendar_today,
                      ),
                    ],
                  ),
                ),
              ),
              elevation: 20.0,
            ).closed.then((value) {
              isBottomSheetShown = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            });
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(
          fabIcon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle_outline,
            ),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.archive_outlined,
            ),
            label: 'Archived',
          ),
        ],
      ),
    );
  }



  void createDatabase() async {
  database = await openDatabase(
    'todo.db',
    version: 1,
    onCreate: (database, version) {
      // ... (existing code)
        print('database created');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
    },
    onOpen: (database) {
      getDataFromDatabase(database).then((value) {
        tasks = value;
        print(tasks);
      });
      print('database opened');
    },
  );

  if (database != null) {
    // Database is initialized, you can proceed with other operations.
  } else {
    print('Error: Database is null.');
  }
}


  Future<int> insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    try {
      final result = await database!.rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$time", "$date", "new")',
      );

      if (result > 0) {
        print('$result inserted successfully');
        return result;
      } else {
        print('Error: Insert operation did not affect any rows.');
        return 0;
      }
    } catch (e) {
      print('Error When Inserting New Record: $e');
      return 0;
    }
  }



  Future<List<Map>> getDataFromDatabase(Database database) async {
  try {
    return await database.rawQuery('SELECT * FROM tasks');
  } catch (e) {
    print('Error fetching data from database: $e');
    return []; // Return an empty list or handle the error as needed
  }
}

}
