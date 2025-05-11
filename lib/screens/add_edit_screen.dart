import 'package:flutter/material.dart';
import 'package:notes_app/model/notes_model.dart';
import 'package:notes_app/screens/widgets/delete_dialog.dart';
import 'package:notes_app/screens/widgets/note_color_picker.dart';
import 'package:notes_app/screens/widgets/note_text_field.dart';
import 'package:notes_app/screens/widgets/save_button.dart';
import 'package:notes_app/service/database_helper.dart';

class AddEditScreen extends StatefulWidget {
  final Note? note;
  const AddEditScreen({super.key, this.note});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Color _selectedColor = const Color(0xFFFFF3E0);
  bool _isSaving = false;

  final List<Color> _colors = [
    const Color(0xFFFFF3E0),
    const Color(0xFFFFCDD2),
    const Color(0xFFBBDEFB),
    const Color(0xFFD1C4E9),
    const Color(0xFFF8BBD0),
    const Color(0xFFC8E6C9),
    const Color(0xFFFFF9C4),
    const Color(0xFFE0E0E0),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = widget.note!.colorValue;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.note == null ? 'New Note' : 'Edit Note',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: false,
        foregroundColor: Colors.black,
        actions: [
          if (widget.note != null)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red[400]),
              onPressed: _isSaving ? null : _deleteNote,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      NoteTextField(
                        controller: _titleController,
                        hintText: 'Title',
                        isTitle: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      NoteTextField(
                        controller: _contentController,
                        hintText: 'Start writing...',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some content';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              NoteColorPicker(
                selectedColor: _selectedColor,
                colors: _colors,
                onColorSelected: (color) {
                  setState(() => _selectedColor = color);
                },
              ),
              const SizedBox(height: 24),
              SaveButton(isLoading: _isSaving, onPressed: _saveNote),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        color: _selectedColor.value.toString(),
        dateTime: DateTime.now().toIso8601String(),
      );

      if (widget.note == null) {
        await _dbHelper.insertNote(note);
      } else {
        await _dbHelper.updateNote(note);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving note: $e'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteNote() async {
    final confirmed = await showDeleteDialog(context);
    if (confirmed != true || widget.note?.id == null) return;

    setState(() => _isSaving = true);

    try {
      await _dbHelper.deleteNote(widget.note!.id!);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting note: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
