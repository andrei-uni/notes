import 'package:notes/core/database/app_database.dart';
import 'package:notes/core/models/note.dart';
import 'package:notes/core/models/note_data.dart';
import 'package:notes/core/models/notes_sort_mode.dart';
import 'package:notes/core/notes_repository/mappers/note_mapper.dart';
import 'package:notes/core/notes_repository/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  NotesRepositoryImpl({
    required this.appDatabase,
  });

  final AppDatabase appDatabase;

  // Обработка ошибок могла бы выглядеть так:
  // Если мы предполагаем, что метод может выкинуть ошибку опеределенного типа,
  // то перехватываем ее и переводим в тип доменного слоя, как сделано в примере.
  // В противном же случае - у нас возникла непредвиденная ситуация, о которой
  // нужно сообщить "наверх", то есть пробрасываем ошибку выше.
  // Она пробросится в метод onError у runZonedGuarded, в который обернуто все приложение.
  // А в нем уже можно залогировать эту ошибку.
  //
  // < ----- Пример ----- >
  //
  // Future<Result<User, LoginError>> login(String email, String password) async {
  //   try {
  //     final userResponse = await authService.login(email, password);
  //     return Result.success(userResponse.toModel());
  //   } on DioException catch (e) {
  //     if (e.response?.statusCode == 401) {
  //       return Result.failure(LoginError.invalidEmailOrPassword);
  //     }
  //     if (e.response?.statusCode == 403) {
  //       return Result.failure(LoginError.userBanned);
  //     }
  //     rethrow;
  //   }
  // }
  //
  // Так как потенциальных ошибок может быть несколько, то можно использовать тип Result.
  // Если данные для входа неверные, либо пользователь заблокирован, то http-клиент
  // выкинет ошибку, которую нам нужно обработать и преобразовать в наш тип LoginError,
  // который может быть enum или sealed class (когда нужно передать какие-то данные вместе с типом ошибки).
  //

  @override
  Future<Note?> getNote({required int noteId}) async {
    try {
      final noteTableData = await appDatabase.getNote(id: noteId);
      return noteTableData.toModel();
    } on StateError {
      // Если в дб не найдется заметка c нужным id, то произойдет StateError.
      // В данном случае не нужна особая обработка ошибки и возврат конкретного типа ошибки,
      // как в примере выше. Так как метод возвращает 'Note?', нам нужно только знать нашлась ли такая
      // заметка или нет.
      return null;
    }
    // Если это не StateError, то сам метод завершится ошибкой, и она пробросится выше.
  }

  @override
  Future<Note> addNote(NoteData note) async {
    final row = note.toRowInsert();
    final newNote = await appDatabase.insertNote(row);
    return newNote.toModel();
  }

  @override
  Future<void> deleteNote({required int noteId}) async {
    await appDatabase.deleteNote(id: noteId);
  }

  @override
  Future<List<Note>> getNotes({
    required int limit,
    required int offset,
    required NotesSortMode notesSortMode,
    required String? searchQuery,
  }) async {
    final rows = await appDatabase.getNotes(
      limit: limit,
      offset: offset,
      notesSortMode: notesSortMode,
      seachQuery: searchQuery,
    );
    return rows.map((r) => r.toModel()).toList();
  }

  @override
  Future<void> updateNote(Note note) async {
    final row = note.toRowUpdate();
    await appDatabase.updateNote(row);
  }
}
