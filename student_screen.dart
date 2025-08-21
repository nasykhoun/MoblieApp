import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'logged_user_model.dart';
import 'message_util.dart';
import 'student_form.dart';
import 'student_login_screen.dart';
import 'student_model.dart';
import 'student_service.dart';

class StudentScreen extends StatefulWidget {
  LoggedUserModel loggedUser;
  StudentScreen(this.loggedUser);

  // const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  late Future<StudentModel> _futureStudent;

  @override
  void initState() {
    super.initState();
    _futureStudent = StudentService.read(this.widget.loggedUser.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Screen"),
        actions: [
          IconButton(
            onPressed: () async {
              bool edited = await Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => StudentForm(this.widget.loggedUser),
                ),
              );

              if (edited) {
                setState(() {
                  _futureStudent = StudentService.read(
                    this.widget.loggedUser.token,
                  );
                });
              }
            },
            icon: Icon(Icons.person_add),
          ),

          IconButton(
            onPressed: () async {
              StudentService.logout(this.widget.loggedUser.token)
                  .then((loggedUser) {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => StudentLoginScreen(),
                      ),
                    );
                  })
                  .onError((e, s) {
                    debugPrint(e.toString());
                  });
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildBody(),
      // body: _testBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureStudent = StudentService.read(this.widget.loggedUser.token);
          });
        },
        child: FutureBuilder<StudentModel>(
          future: _futureStudent,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _buildError(snapshot.error);
            }

            if (snapshot.connectionState == ConnectionState.done) {
              debugPrint("model = ${snapshot.data}");

              return _buildDataModel(snapshot.data);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDataModel(StudentModel? model) {
    if (model == null) {
      return SizedBox();
    }

    return _buildListView(model.data);
  }

  Widget _buildError(Object? error) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error),
          Text(error.toString()),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _futureStudent = StudentService.read(
                  this.widget.loggedUser.token,
                );
              });
            },
            icon: Icon(Icons.refresh),
            label: Text("RETRY"),
          ),
        ],
      ),
    );
  }

  void _deleteItem(Datum item) async {
    bool deleted = await showDeleteDialog(context) ?? false;
    if (deleted) {
      StudentService.delete(item.sid, this.widget.loggedUser.token)
          .then((value) {
            if (value == true) {
              setState(() {
                _futureStudent = StudentService.read(
                  this.widget.loggedUser.token,
                );
              });
            }
          })
          .onError((e, s) {
            debugPrint(e.toString());
          });
    }
  }

  Widget _buildListView(List<Datum> items) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          direction: DismissDirection.endToStart,
          key: UniqueKey(),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              _deleteItem(item);
            }
          },
          child: Card(
            child: ListTile(
              title: Text(item.name),
              trailing: IconButton(
                onPressed: () async {
                  _deleteItem(item);
                },
                icon: Icon(Icons.delete),
              ),
              onTap: () async {
                bool edited = await Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder:
                        (context) => StudentForm(
                          this.widget.loggedUser,
                          item: item,
                          editMode: true,
                        ),
                  ),
                );

                if (edited) {
                  setState(() {
                    _futureStudent = StudentService.read(
                      this.widget.loggedUser.token,
                    );
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }
}
