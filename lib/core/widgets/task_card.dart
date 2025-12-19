import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class TaskCard extends StatefulWidget {
  final String title;
  final String description;
  final bool isCompleted;
  final ValueChanged<bool?> onToggle;
  final ValueChanged<String>? onDescriptionChanged;
  final VoidCallback? onTap;

  const TaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.onToggle,
    this.onDescriptionChanged,
    this.onTap,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.description);
  }

  @override
  void didUpdateWidget(covariant TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.description != widget.description &&
        _controller.text != widget.description) {
      _controller.text = widget.description;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    decoration: widget.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: widget.isCompleted,
                    onChanged: widget.onToggle,
                    activeColor: AppColors.primary,
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    side: const BorderSide(color: Colors.black, width: 1.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Digite aqui...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTextStyles.bodyMedium,
              onSubmitted: widget.onDescriptionChanged,
            ),
          ],
        ),
      ),
    );
  }
}
