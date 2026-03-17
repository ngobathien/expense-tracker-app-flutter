import 'package:flutter/material.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List expenses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý chi tiêu")),

      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final e = expenses[index];

          return Card(
            child: ListTile(
              title: Text("${e.amount} VND"),
              subtitle: Text(e.category),
              trailing: Text(e.type),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );

          if (result != null) {
            setState(() {
              expenses.add(result);
            });
          }
        },
        child: const Icon(Icons.add),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.home),
              Icon(Icons.bar_chart),
              SizedBox(width: 40),
              Icon(Icons.map),
              Icon(Icons.settings),
            ],
          ),
        ),
      ),
    );
  }
}
