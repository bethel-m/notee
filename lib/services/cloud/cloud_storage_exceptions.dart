class CloudStorageExcetion implements Exception {
  const CloudStorageExcetion();
}

class CouldNotCreateNoteException extends CloudStorageExcetion {}

class CouldNotGetAllNotesException extends CloudStorageExcetion {}

class CouldNotDeleteNotesException extends CloudStorageExcetion {}

class CouldNotUpdateNoteException extends CloudStorageExcetion {}
