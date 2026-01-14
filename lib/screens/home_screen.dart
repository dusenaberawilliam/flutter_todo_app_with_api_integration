import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/view_models/todo_view_model.dart';
import 'package:todo_app/widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) return;

      context.read<TodoViewModel>().fetchTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodoViewModel>();

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          _searchContainer(),
          SizedBox(height: 10.0),
          _todoListExpanded(viewModel),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddTodoBottomSheet(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Container _searchContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for task',
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: Icon(Icons.tune, color: Colors.grey),
        ),
      ),
    );
  }

  Expanded _todoListExpanded(TodoViewModel viewModel) {
    return Expanded(
      child: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: viewModel.todos.length,
              itemBuilder: (context, index) {
                final todo = viewModel.todos[index];

                return Dismissible(
                  key: ValueKey(todo.id),
                  direction: DismissDirection.endToStart, // right → left
                  confirmDismiss: (direction) async {
                    return await _showDeleteDialog(context);
                  },
                  onDismissed: (_) {
                    context.read<TodoViewModel>().deleteTodo(todo.id);
                  },
                  background: _deleteBackground(),
                  child: _todoCard(context, todo),
                );
              },
            ),
    );
  }

  Widget _todoCard(BuildContext context, todo) {
    return Card(
      margin: const EdgeInsets.all(6),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        title: Text(
          todo.todo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            decoration: todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          todo.completed ? "Completed" : "Not done yet",
          style: TextStyle(
            fontSize: 12,
            color: todo.completed
                ? const Color.fromARGB(255, 54, 92, 55)
                : Colors.blueGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Checkbox(
          value: todo.completed,
          activeColor: Colors.blue,
          onChanged: (_) {
            context.read<TodoViewModel>().updateTodo(todo.id, todo.completed);
          },
        ),
      ),
    );
  }

  void _openAddTodoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  _dragHandle(),
                  const SizedBox(height: 16),
                  _addTodoForm(context),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Bottom sheet
  Widget _addTodoForm(BuildContext context) {
    final controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Add New Todo",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Todo title",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<TodoViewModel>().addTodo(controller.text);

                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Add Todo"),
          ),
        ),
      ],
    );
  }

  Widget _dragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _deleteBackground() {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.delete, color: Colors.white, size: 28),
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Delete Todo"),
              content: const Text("Do you really want to delete this todo?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
