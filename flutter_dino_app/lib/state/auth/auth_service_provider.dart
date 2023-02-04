import 'package:flutter_dino_app/data/datasource/api/repositories/api_auth_repository.dart';
import 'package:flutter_dino_app/data/datasource/local/database/database_source.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasource/local/repositories/local_auth_repository.dart';
import '../../domain/services/auth_service.dart';
import '../api_consumer/api_consumer.dart';
import '../db/local_db_provider.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final consumer = ref.read(apiProvider);
  final DatabaseSource db = ref.read(localDbProvider);
  final authRepository = ApiAuthRepository(consumer);
  final locAuthRepository = LocalAuthRepository(db);

  return AuthService(authRepository, locAuthRepository);
});