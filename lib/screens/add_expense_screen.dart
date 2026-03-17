import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String category = "Ăn uống";
  String type = "Chi";
  DateTime selectedDate = DateTime.now();

  final List<String> categories = [
    "Ăn uống",
    "Di chuyển",
    "Mua sắm",
    "Giải trí",
  ];

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // void saveExpense() {
  //   print("Amount: ${amountController.text}");
  //   print("Category: $category");
  //   print("Note: ${noteController.text}");
  //   print("Date: $selectedDate");
  //   print("Type: $type");

  //   Navigator.pop(context);
  // }

  void saveExpense() {
    final expense = Expense(
      amount: double.parse(amountController.text),
      category: category,
      note: noteController.text,
      date: selectedDate,
      type: type,
    );

    Navigator.pop(context, expense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm khoản chi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// SỐ TIỀN
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Số tiền",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// DANH MỤC
            DropdownButtonFormField(
              value: category,
              items: categories.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Danh mục",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// GHI CHÚ
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: "Ghi chú",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// CHỌN NGÀY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ngày: ${selectedDate.toString().split(" ")[0]}",
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: pickDate,
                  child: const Text("Chọn ngày"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// LOẠI THU / CHI
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text("Chi"),
                    value: "Chi",
                    groupValue: type,
                    onChanged: (value) {
                      setState(() {
                        type = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("Thu"),
                    value: "Thu",
                    groupValue: type,
                    onChanged: (value) {
                      setState(() {
                        type = value!;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// NÚT LƯU
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveExpense,
                child: const Text("Lưu"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
