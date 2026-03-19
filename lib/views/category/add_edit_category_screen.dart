import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';
import '../../viewmodels/category_viewmodel.dart';

class AddEditCategoryScreen extends StatefulWidget {
  final CategoryModel? category;
  final String? type;

  const AddEditCategoryScreen({super.key, this.category, this.type});

  @override
  State<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();

  String icon = '📁';
  String color = '#FF7B00';
  String type = 'expense';

  final List<String> icons = [
    '🍔',
    '🚗',
    '🎬',
    '💰',
    '🛍️',
    '🏠',
    '🏥',
    '🎓',
    '🎁',
    '✈️',
    '📱',
    '💡',
  ];

  final List<String> colors = [
    '#ff7b00',
    '#3b82f6',
    '#a855f7',
    '#22c55e',
    '#ef4444',
    '#f59e0b',
    '#06b6d4',
    '#6366f1',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      icon = widget.category!.icon;
      color = widget.category!.color;
      type = widget.category!.type;
    } else {
      type = widget.type ?? 'expense';
    }
  }

  Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CategoryViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xfff8f7f5),

      /// HEADER
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          widget.category == null ? 'Thêm hạng mục' : 'Sửa hạng mục',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xffFF7B00)),
            onPressed: () async {
              final model = CategoryModel(
                id: widget.category?.id,
                name: _nameController.text,
                type: type,
                icon: icon,
                color: color,
              );

              bool success;

              if (widget.category == null) {
                success = await vm.addCategory(model);
              } else {
                success = await vm.updateCategory(model);
              }

              if (success) Navigator.pop(context);
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// ICON PREVIEW + INPUT
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: hexToColor(color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(icon, style: const TextStyle(fontSize: 40)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Tên hạng mục',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// ICON PICKER
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CHỌN BIỂU TƯỢNG',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: icons.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemBuilder: (_, index) {
                      final i = icons[index];
                      final isSelected = i == icon;

                      return GestureDetector(
                        onTap: () => setState(() => icon = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(
                                    color: const Color(0xffFF7B00),
                                    width: 2,
                                  )
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(i, style: TextStyle(fontSize: 22)),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// COLOR PICKER
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CHỌN MÀU SẮC',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: colors.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemBuilder: (_, index) {
                      final c = colors[index];
                      final isSelected = c == color;

                      return GestureDetector(
                        onTap: () => setState(() => color = c),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: hexToColor(c),
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(color: Colors.grey, width: 2)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              /// DELETE BUTTON (chỉ khi edit)
              if (widget.category != null)
                GestureDetector(
                  onTap: () async {
                    final success = await vm.deleteCategory(
                      widget.category!.id!,
                    );
                    if (success) Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'Xóa hạng mục',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
