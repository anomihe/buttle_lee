/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class Book implements _i1.SerializableModel {
  Book._({
    this.id,
    required this.userId,
    required this.title,
    required this.author,
    required this.status,
    required this.startedDate,
    this.finishedDate,
  });

  factory Book({
    int? id,
    required int userId,
    required String title,
    required String author,
    required int status,
    required DateTime startedDate,
    DateTime? finishedDate,
  }) = _BookImpl;

  factory Book.fromJson(Map<String, dynamic> jsonSerialization) {
    return Book(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      title: jsonSerialization['title'] as String,
      author: jsonSerialization['author'] as String,
      status: jsonSerialization['status'] as int,
      startedDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedDate'],
      ),
      finishedDate: jsonSerialization['finishedDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['finishedDate'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String title;

  String author;

  int status;

  DateTime startedDate;

  DateTime? finishedDate;

  /// Returns a shallow copy of this [Book]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Book copyWith({
    int? id,
    int? userId,
    String? title,
    String? author,
    int? status,
    DateTime? startedDate,
    DateTime? finishedDate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Book',
      if (id != null) 'id': id,
      'userId': userId,
      'title': title,
      'author': author,
      'status': status,
      'startedDate': startedDate.toJson(),
      if (finishedDate != null) 'finishedDate': finishedDate?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BookImpl extends Book {
  _BookImpl({
    int? id,
    required int userId,
    required String title,
    required String author,
    required int status,
    required DateTime startedDate,
    DateTime? finishedDate,
  }) : super._(
         id: id,
         userId: userId,
         title: title,
         author: author,
         status: status,
         startedDate: startedDate,
         finishedDate: finishedDate,
       );

  /// Returns a shallow copy of this [Book]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Book copyWith({
    Object? id = _Undefined,
    int? userId,
    String? title,
    String? author,
    int? status,
    DateTime? startedDate,
    Object? finishedDate = _Undefined,
  }) {
    return Book(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      author: author ?? this.author,
      status: status ?? this.status,
      startedDate: startedDate ?? this.startedDate,
      finishedDate: finishedDate is DateTime?
          ? finishedDate
          : this.finishedDate,
    );
  }
}
