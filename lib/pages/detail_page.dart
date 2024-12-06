import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class DetailPage extends StatefulWidget {
  final int index;

  const DetailPage({Key? key, required this.index}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

String _getDayName(int weekday) {
  const dayNames = [
    'Minggu', // 0: Tidak akan pernah terjadi di DateTime
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
  ];
  return dayNames[weekday];
}

String _formatTime(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

class _DetailPageState extends State<DetailPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  late Task task; // Variabel global untuk task

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    task = taskProvider.tasks[widget.index];

    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _selectedDate = task.dateTime;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _editTask(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final updatedTask = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      dateTime: _selectedDate!,
    );

    taskProvider.editTask(widget.index, updatedTask);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil diperbarui!')),
    );

    Navigator.pop(context);
  }

  void _deleteTask(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    taskProvider.deleteTask(widget.index);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil dihapus!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('Tanggal dan Waktu: '),
                TextButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate!,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_selectedDate!),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _selectedDate = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                        });
                      }
                    }
                  },
                  child: const Text('Pilih Tanggal dan Waktu'),
                ),
              ],
            ),
            if (_selectedDate != null)
              Text(
                '${_getDayName(_selectedDate!.weekday)}, ${_formatTime(_selectedDate!)}',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () => _deleteTask(context),
                  child: const Text('Hapus'),
                ),
                ElevatedButton(
                  onPressed: () => _editTask(context),
                  child: const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
