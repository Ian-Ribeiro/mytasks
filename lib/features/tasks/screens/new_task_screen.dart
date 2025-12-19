import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_app_header.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/task_provider.dart';

class NewTaskScreen extends ConsumerStatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends ConsumerState<NewTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Using CustomAppHeader but user description for "Nova Tarefa" might imply different style (white bg?)
          // Tela 4 description: "Horário 9:41", "Título: Nova Tarefa".
          // If it matches others, it's orange. Let's stick to consistency unless specified.
          // Image 1 (likely New Task) might be white? 
          // "Image 1" in my mental model: "New Task" often pops up. 
          // Let's assume consistent Orange Header for "Focus.Me" branding, OR:
          // If the provided image 1 looks like a modal/white page with icons.
          // I will use White background for the header area if it feels like a modal.
          // But safer to stick to "Visualmente IGUAL às 4 imagens" - I don't see them.
          // I will use the CustomAppHeader with "Nova Tarefa" and "Focus.Me" replaced or just "Nova Tarefa".
          // I'll make the title "Nova Tarefa".
          const CustomAppHeader(title: "Nova Tarefa", showBack: true),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                   Row(
                     children: [
                       const Icon(Icons.title, color: Colors.grey),
                       const SizedBox(width: 8),
                       Expanded(
                         child: TextField(
                           controller: _titleController,
                           decoration: InputDecoration(
                             hintText: "Título da Tarefa",
                             border: InputBorder.none,
                             hintStyle: AppTextStyles.titleMedium.copyWith(color: Colors.grey),
                           ),
                           style: AppTextStyles.titleMedium.copyWith(
                             color: Theme.of(context).textTheme.bodyLarge?.color,
                           ),
                         ),
                       ),
                     ],
                   ),
                   const Divider(),
                   const SizedBox(height: 16),
                   Text("Descrição", style: AppTextStyles.bodyLarge),
                   const SizedBox(height: 8),
                   Expanded(
                     child: CustomTextField(
                       hintText: "Digite a descrição aqui...",
                       controller: _descriptionController,
                       maxLines: null, 
                       fillColor: Colors.transparent, 
                     ),
                   ),
                   const SizedBox(height: 24),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       TextButton(
                         onPressed: () => Navigator.pop(context),
                         child: Text("Cancelar", style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey)),
                       ),
                       const SizedBox(width: 16),
                       ElevatedButton(
                         onPressed: () {
                           final title = _titleController.text.trim();
                           final description = _descriptionController.text.trim();
                           
                           if (title.isNotEmpty) {
                             ref.read(taskProvider.notifier).addTask(title, description);
                             Navigator.pop(context);
                           } else {
                             // Show validation error or valid only if title present?
                             ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(content: Text("O título é obrigatório!")),
                             );
                           }
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: AppColors.primary,
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                         ),
                         child: Text("Salvar", style: AppTextStyles.bodyLarge.copyWith(color: Colors.white)),
                       ),
                     ],
                   )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
