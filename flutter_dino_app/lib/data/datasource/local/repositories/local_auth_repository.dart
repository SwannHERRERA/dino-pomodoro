import 'dart:convert';
import 'dart:io';
import 'package:flutter_dino_app/data/datasource/local/database/database_source.dart';
import '../../../../core/success.dart';
import '../../../../domain/models/user_auth.dart';
import '../../../../domain/repositories/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  final DatabaseSource dbSource;


  LocalAuthRepository(this.dbSource);

  @override
  Future<Success<UserAuth>> login(String email, String password) async {
    return Future.value(Success.fromFailure(failureMessage: "Not implemented"));
  }

  @override
  Future<Success<UserAuth>> retrieveUserAuth() async {
    final db = await dbSource.db();

    final result = await db.query('user_auth', limit: 1);
    if (result.isEmpty) {
      return Success.fromFailure(failureMessage: "No user auth found");
    }

    final userAuth = UserAuth.fromJson(jsonDecode(result.first['json'] as String));
    return Success(data: userAuth);
  }

  @override
  Future<Success<void>> saveUserAuth(UserAuth userAuth) async {
    final db = await dbSource.db();
    await db.delete('user_auth');
    await db.insert('user_auth', {
      'id': userAuth.user.id,
      'json': userAuth.toJson(),
    });
    return Future.value(Success(data: null));
  }

  @override
  Future<Success<void>> logout() async {
    final db = await dbSource.db();
    await db.delete('user_auth');
    return Future.value(Success(data: null));
  }

  @override
  Future<Success<UserAuth>> updateUserInfo(UserAuth userAuth) async {
    final result = await saveUserAuth(userAuth);
    if (result.isSuccess) {
      return Success(data: userAuth);
    }
    return Success.fromFailure(failureMessage: "Failed to update user auth");
  }
import 'package:flutter_dino_app/data/datasource/local/database/database_source.dart';
import '../../../../core/success.dart';
import '../../../../domain/models/user_auth.dart';
import '../../../../domain/repositories/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  final DatabaseSource dbSource;


  LocalAuthRepository(this.dbSource);

  @override
  Future<Success<UserAuth>> login(String email, String password) async {
    return Future.value(Success.fromFailure(failureMessage: "Not implemented"));
  }

  @override
  Future<Success<UserAuth>> retrieveUserAuth() async {
    final db = await dbSource.db();

    final result = await db.query('user_auth', limit: 1);
    if (result.isEmpty) {
      return Success.fromFailure(failureMessage: "No user auth found");
    }

    final userAuth = UserAuth.fromJson(jsonDecode(result.first['json'] as String));
    return Success(data: userAuth);
  }

  @override
  Future<Success<void>> saveUserAuth(UserAuth userAuth) async {
    final db = await dbSource.db();
    await db.delete('user_auth');
    await db.insert('user_auth', {
      'id': userAuth.user.id,
      'json': userAuth.toJson(),
    });
    return Future.value(Success(data: null));
  }


}
