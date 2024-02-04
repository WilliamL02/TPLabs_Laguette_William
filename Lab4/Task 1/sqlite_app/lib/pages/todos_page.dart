import 'package:flutter/material.dart';
import 'package:sqlite_app/model/todo.dart';
import 'package:sqlite_app/database/todo_db.dart';
import 'package:sqlite_app/widgets/create_todo_widget.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  Future<List<Todo>>? futureTodos;
  final todoDB = TodoDB();

  @override
  void initState() {
    super.initState();

    fetchTodos();
  }

  void fetchTodos() {
    setState(() {
      futureTodos = todoDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('To-Do List'),
        ),
        body: FutureBuilder<List<Todo>>(
          future: futureTodos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final List<Todo> todos = snapshot.data!;

              return todos.isEmpty
                  ? const Center(
                      child: Text('No todos..'),
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return ListTile(
                          title: Text(todo.title),
                          trailing: IconButton(
                            onPressed: () async {
                              todoDB.delete(todo.id);
                              fetchTodos();
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => CreateTodoWidget(
                                todo: todo,
                                onSubmit: (title) async {
                                  await todoDB.update(
                                      id: todo.id, title: title);
                                  fetchTodos();
                                  if (!mounted) return;
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => CreateTodoWidget(onSubmit: (title) async {
                      await todoDB.insert(title: title);
                      if (!mounted) return;
                      fetchTodos();
                      Navigator.of(context).pop();
                    }));
          },
        ),
      );
}
