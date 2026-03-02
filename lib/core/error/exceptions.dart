class ServerException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;

  ServerException({required this.message, this.errors});

  // هذه الدالة السحرية تمنع ظهور "Instance of ServerException"
  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});

  @override
  String toString() => message;
}
