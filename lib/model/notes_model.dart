import 'dart:ui';

class Note {
  final int? id;
  final String title;
  final String content;
  final String color;
  final String dateTime;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.dateTime,
  });

  Color get colorValue => Color(int.parse(color));
  DateTime get dateTimeValue => DateTime.parse(dateTime);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'dateTime': dateTime,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'] ?? '', // Handle potential null
      color: map['color'],
      dateTime: map['dateTime'],
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    String? color,
    String? dateTime,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}