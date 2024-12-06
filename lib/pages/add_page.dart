import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Judul
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 16.0),

            // Input Deskripsi
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),

            // Tombol Pilih Tanggal dan Waktu
            ElevatedButton(
              onPressed: () async {
                // Pilih tanggal
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (selectedDate == null) return;

                // Pilih waktu
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (selectedTime == null) return;

                // Gabungkan tanggal dan waktu
                setState(() {
                  _selectedDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                });
              },
              child: const Text('Pilih Tanggal & Waktu'),
            ),
            const SizedBox(height: 8.0),

            // Tampilkan Tanggal dan Waktu yang Dipilih
            if (_selectedDateTime != null)
              Text(
                'Dipilih: ${_formatDateTime(_selectedDateTime!)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 16.0),

            // Tombol Submit
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty ||
                    _descriptionController.text.isEmpty ||
                    _selectedDateTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Harap lengkapi semua input!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Buat task baru
                final task = Task(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  dateTime: _selectedDateTime!,
                );

                // Tambahkan task menggunakan provider
                Provider.of<TaskProvider>(context, listen: false).addTask(task);

                // Tampilkan popup berhasil
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data berhasil ditambahkan!'),
                    backgroundColor: Colors.green,
                  ),
                );

                // Navigasi kembali ke homepage
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  /// Format tanggal dan waktu menjadi string yang mudah dibaca
  String _formatDateTime(DateTime dateTime) {
    final date = '${dateTime.day}-${dateTime.month}-${dateTime.year}';
    final time =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }
}
