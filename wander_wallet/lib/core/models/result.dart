sealed class Result<SuccessType, ErrorType> {
  Result();
}

class Success<SuccessType, ErrorType> extends Result<SuccessType, ErrorType> {
  final SuccessType data;

  Success(this.data);
}

class Error<SuccessType, ErrorType> extends Result<SuccessType, ErrorType> {
  final ErrorType error;
  final bool loggedOut;

  Error({required this.error, this.loggedOut = false});
}