import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/transaction_model.dart';
import '../../viewmodels/category_viewmodel.dart';
import '../../viewmodels/stats_viewmodel.dart';
import '../../viewmodels/transaction_viewmodel.dart';
import '../transactions/widgets/input_box.dart';
import '../transactions/widgets/toggle_item.dart';
import '../widgets/custom_button.dart';
import '../widgets/helpers.dart';

class AddEditTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const AddEditTransactionScreen({super.key, this.transaction});

  @override
  State<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  bool isExpense = true;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      final t = widget.transaction!;
      amountController.text = t.amount.toString();
      titleController.text = t.name;
      noteController.text = t.note ?? '';
      selectedDate = t.date;
      isExpense = t.type == 'expense';

      // Gán ngay lập tức ở đây
      selectedCategoryId = t.categoryId;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<CategoryViewModel>().fetchCategories();
      // Không cần setState lại categoryId ở đây nếu t.categoryId đã chuẩn String
    });
  }

  /// Xử lý khi nhấn Toggle Chi tiêu/Thu nhập
  void _onToggleType(bool value) {
    if (isExpense == value) return;
    setState(() {
      isExpense = value;
      // Reset highlight nếu category cũ không thuộc loại mới (Yêu cầu 4)
      selectedCategoryId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f7f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.transaction == null ? 'Thêm giao dịch' : 'Chỉnh sửa giao dịch',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          if (widget.transaction != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showDeleteConfirmDialog(context),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Tab Chi tiêu / Thu nhập
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ToggleItem(
                            title: 'Chi tiêu',
                            isActive: isExpense,
                            onTap: () => _onToggleType(true),
                          ),
                        ),
                        Expanded(
                          child: ToggleItem(
                            title: 'Thu nhập',
                            isActive: !isExpense,
                            onTap: () => _onToggleType(false),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// Input Số tiền
                  Column(
                    children: [
                      const Text(
                        "Số tiền",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFF7B00),
                        ),
                        decoration: const InputDecoration(
                          hintText: "0",
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Input Tiêu đề
                  InputBox(
                    label: "Tiêu đề",
                    child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "Nhập tiêu đề...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Chọn Ngày
                  InputBox(
                    label: "Ngày giao dịch",
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null)
                          setState(() => selectedDate = picked);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          ),
                          const Icon(Icons.calendar_today_outlined, size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Grid Hạng mục
                  const Text(
                    "Hạng mục",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Consumer<CategoryViewModel>(
                    builder: (context, vm, _) {
                      if (vm.isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      // Lọc danh sách theo loại hiện tại (Yêu cầu 2)
                      final filteredList = vm.categories
                          .where(
                            (c) => c.type == (isExpense ? "expense" : "income"),
                          )
                          .toList();

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.85,
                            ),
                        itemBuilder: (_, index) {
                          // Trong GridView.builder -> itemBuilder
                          final category = filteredList[index];

                          // Sử dụng so sánh trực tiếp (đã đảm bảo cả 2 là String)
                          final isSelected =
                              selectedCategoryId.toString() ==
                              category.id.toString();
                          return GestureDetector(
                            onTap: () {
                              setState(
                                () => selectedCategoryId = category.id,
                              ); // (Yêu cầu 5)
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.orange.withOpacity(0.15)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.orange
                                          : Colors
                                                .transparent, // Highlight màu cam (Yêu cầu 8)
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _getIconData(category.icon),
                                    color: isSelected
                                        ? Colors.orange
                                        : _parseColor(category.color),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  category.name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Colors.orange
                                        : Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          /// Nút Hành động
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: CustomButton(
              text: widget.transaction == null ? "Thêm giao dịch" : "Cập nhật",
              onPressed: _onSave,
            ),
          ),
        ],
      ),
    );
  }

  /// Logic Lưu dữ liệu
  Future<void> _onSave() async {
    final title = titleController.text.trim();
    final amountStr = amountController.text.trim();

    if (title.isEmpty || amountStr.isEmpty || selectedCategoryId == null) {
      showMessage(
        context,
        "Vui lòng điền đủ Tiêu đề, Số tiền và Hạng mục",
        success: false,
      );
      return;
    }

    final amount = double.tryParse(amountStr) ?? 0;
    final transaction = TransactionModel(
      id: widget.transaction?.id,
      amount: amount,
      type: isExpense ? "expense" : "income",
      name: title,
      note: noteController.text.trim(),
      date: selectedDate,
      categoryId: selectedCategoryId!,
    );

    final txVM = context.read<TransactionViewModel>();
    final statsVM = context.read<StatsViewModel>();

    bool success;
    if (widget.transaction == null) {
      success = await txVM.addTransaction(transaction);
      if (success) statsVM.addTransactionRealtime(transaction);
    } else {
      success = await txVM.updateTransaction(
        widget.transaction!.id!,
        transaction,
      );
      if (success) statsVM.updateTransactionRealtime(transaction);
    }

    if (success && mounted) {
      showMessage(context, "Thành công!", success: true);
      Navigator.pop(context, true);
    } else {
      showMessage(context, "Lỗi: ${txVM.error}", success: false);
    }
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc muốn xóa giao dịch này?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);

              final txVM = context.read<TransactionViewModel>();
              final statsVM = context.read<StatsViewModel>();

              final success = await txVM.deleteTransaction(
                widget.transaction!.id!,
              );

              if (success) {
                statsVM.deleteTransactionRealtime(widget.transaction!);

                if (mounted) Navigator.pop(context, true);
              }
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Các hàm Helper hỗ trợ Icon và Màu
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'home':
        return Icons.home;
      case 'commute':
        return Icons.commute;
      case 'medical_services':
        return Icons.medical_services;
      case 'school':
        return Icons.school;
      case 'payments':
        return Icons.payments;
      case 'work':
        return Icons.work;
      case 'trending_up':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }

  Color _parseColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.blueGrey;
    }
  }
}
