import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final String creatorId;
  final List<String> sharedWith;
  final Timestamp createdAt;

  TaskModel({
    String? id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.creatorId,
    this.sharedWith = const [],
    Timestamp? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? Timestamp.now();

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      isCompleted: map['isCompleted'],
      creatorId: map['creatorId'],
      sharedWith: List<String>.from(map['sharedWith']),
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
      'creatorId': creatorId,
      'sharedWith': sharedWith,
      'createdAt': createdAt,
    };
  }

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    List<String>? sharedWith,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      creatorId: creatorId,
      sharedWith: sharedWith ?? this.sharedWith,
      createdAt: createdAt,
    );
  }
}