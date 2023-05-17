// login exceptions
class WrongPasswordAuthException implements Exception {}

class UserNotFoundAuthException implements Exception {}

//register exceptions
class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

//generic auth exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
