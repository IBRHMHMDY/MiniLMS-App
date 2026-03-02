class ServerException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;

  ServerException({required this.message, this.errors});
}

class CacheException implements Exception {}
