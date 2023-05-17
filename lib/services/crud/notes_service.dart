// import 'dart:async';

// import 'package:notee/extensions/list/filter.dart';
// import 'package:notee/constants/storage_constants.dart';
// import 'package:notee/services/crud/crud_exceptions.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class NotesService {
//   Database? _db;

//   List<DatabaseNote> _notes = [];

//   DatabaseUser? _user;

//   NotesService._sharedInstance() {
//     _notesStreamController =
//         StreamController<List<DatabaseNote>>.broadcast(onListen: () {
//       _notesStreamController.sink.add(_notes);
//     });
//   }
//   static final NotesService _shared = NotesService._sharedInstance();
//   factory NotesService() => _shared;

//   late final StreamController<List<DatabaseNote>> _notesStreamController;
//   Stream<List<DatabaseNote>> get allNotes =>
//       _notesStreamController.stream.filter((note) {
//         final user = _user;
//         if (user != null) {
//           return note.userId == user.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotes();
//         }
//       });
//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       _user = user;
//       return user;
//     } on CouldNotFindUser {
//       final createdUser = await createUser(email: email);
//       _user = createdUser;
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _cacheNotes() async {
//     final allNotes = await getAllNotes();
//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }

//   Future<DatabaseNote> updateNote({
//     required DatabaseNote note,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = getDatabaseOrThrow();
//     await getNote(id: note.id);
//     final updatesCount = await db.update(
//       noteTable,
//       {
//         textColumn: text,
//         isSynchronizedWithCloudColumn: 0,
//       },
//       where: "id = ?",
//       whereArgs: [note.id],
//     );
//     if (updatesCount == 0) {
//       throw CouldNotUpdateNote();
//     } else {
//       final updatedNote = await getNote(id: note.id);
//       _notes.removeWhere((note) => note.id == updatedNote.id);
//       _notes.add(updatedNote);
//       _notesStreamController.add(_notes);
//       return updatedNote;
//     }
//   }

//   Future<Iterable<DatabaseNote>> getAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = getDatabaseOrThrow();
//     final notesList = await db.query(noteTable);
//     final notes = notesList.map((noteItem) => DatabaseNote.fromRow(noteItem));
//     return notes;
//   }

//   Future<DatabaseNote> getNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = getDatabaseOrThrow();
//     final notesList =
//         await db.query(noteTable, where: "id = ?", whereArgs: [id], limit: 1);
//     if (notesList.isEmpty) {
//       throw CouldNotFindNote();
//     } else {
//       final note = DatabaseNote.fromRow(notesList.first);
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _notesStreamController.add(_notes);
//       return note;
//     }
//   }

//   Future<int> deleteAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = getDatabaseOrThrow();
//     final deletedCount = await db.delete(noteTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return deletedCount;
//   }

//   Future<void> deleteNotes({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       noteTable,
//       where: "id = ?",
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNote();
//     } else {
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   Future<DatabaseNote> createNotes({required DatabaseUser owner}) async {
//     await _ensureDbIsOpen();
//     final db = getDatabaseOrThrow();
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }
//     const text = '';
//     final noteId = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSynchronizedWithCloudColumn: 1
//     });
//     final note = DatabaseNote(
//         id: noteId,
//         text: text,
//         userId: owner.id,
//         isSynchronizedWithCloud: true);

//     _notes.add(note);
//     _notesStreamController.add(_notes);
//     return note;
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = getDatabaseOrThrow();
//     final userList = await db.query(
//       userTable,
//       limit: 1,
//       where: "email = ?",
//       whereArgs: [
//         email.toLowerCase(),
//       ],
//     );
//     if (userList.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       final user = DatabaseUser.fromRow(userList.first);
//       return user;
//     }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = getDatabaseOrThrow();
//     final userList = await db.query(
//       userTable,
//       limit: 1,
//       where: "email = ?",
//       whereArgs: [
//         email.toLowerCase(),
//       ],
//     );
//     if (userList.isNotEmpty) {
//       throw UserAlreadyExists();
//     }
//     final userId = await db.insert(
//       userTable,
//       {
//         emailColumn: email,
//       },
//     );
//     return DatabaseUser(
//       id: userId,
//       email: email,
//     );
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       userTable,
//       where: "email=?",
//       whereArgs: [
//         email.toLowerCase(),
//       ],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUser();
//     }
//   }

//   Future<void> _ensureDbIsOpen() async {
//     try {
//       open();
//     } on DatabaseAlreadyOpenException {
//       // just catch the error
//     }
//   }

//   Database getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseNotOpened();
//     } else {
//       return db;
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     } else {
//       try {
//         final docsPath = await getApplicationDocumentsDirectory();
//         final dbPath = join(docsPath.path, dbName);
//         final db = await openDatabase(dbPath);
//         _db = db;
//         //create user table
//         await db.execute(createUserTable);
//         // create notes table
//         await db.execute(createNoteTable);
//         await _cacheNotes();
//       } on MissingPlatformDirectoryException {
//         throw UnableToGetDocumentsDirectory();
//       }
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseNotOpened();
//     } else {
//       db.close();
//       _db = null;
//     }
//   }
// }

// class DatabaseUser {
//   final int id;
//   final String email;

//   const DatabaseUser({required this.id, required this.email});
//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() {
//     return "Person--, ID = $id, email=$email";
//   }

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseNote {
//   final int id;
//   final String text;
//   final int userId;
//   final bool isSynchronizedWithCloud;

//   DatabaseNote(
//       {required this.id,
//       required this.text,
//       required this.userId,
//       required this.isSynchronizedWithCloud});

//   DatabaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSynchronizedWithCloud =
//             map[isSynchronizedWithCloudColumn] as int == 1 ? true : false;

//   @override
//   String toString() {
//     return "Notes ID: $id, userId: $userId, issynchronizedWithCloud: $isSynchronizedWithCloud";
//   }

//   @override
//   bool operator ==(covariant DatabaseNote other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }
