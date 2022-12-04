import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/user.dart';

final authNotifierProvider =
    StateNotifierProvider.autoDispose<AuthNotifier, User?>(
  (ref) => AuthNotifier()..init(),
);

///
/// AuthNotifier
///
class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null);

  late Client client;
  late Account account;
  late Storage storage;

  ///
  /// 初期処理
  ///
  void init() {
    client = Client();
    client
        .setEndpoint('https://localhost/v1') // エンドポイント
        .setProject('xxxxxxxxxxxxxxxxxxxx') // プロジェクトID
        .setSelfSigned();
    account = Account(client);
    storage = Storage(client);
  }

  ///
  /// アカウント作成
  /// @param name: ユーザー名
  /// @param email: メールアドレス
  /// @param password: パスワード
  ///
  Future<void> create(String name, String email, String password) async {
    try {
      final result = await account.create(
        userId: ID.unique(),
        name: name,
        email: email,
        password: password,
      );

      state = User.fromJson(result.toMap());
      log('create: success userId<${result.$id}>');
    } on AppwriteException catch (e) {
      log('create: ${e.message!}');
    }
  }

  ///
  /// ログイン
  /// @param email: メールアドレス
  /// @param password: パスワード
  ///
  Future<void> login(String email, String password) async {
    try {
      final result =
          await account.createEmailSession(email: email, password: password);
      state = await _getAccount();
      log('login: success userId<${result.userId}>');
    } on AppwriteException catch (e) {
      log('login: ${e.message!}');
    }
  }

  ///
  /// ログアウト
  ///
  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      state = null;
      log('logout: success');
    } on AppwriteException catch (e) {
      log('logout: ${e.message!}');
    }
  }

  ///
  /// アカウント取得
  ///
  Future<User?> _getAccount() async {
    try {
      final result = await account.get();
      return User.fromJson(result.toMap());
    } on AppwriteException catch (e) {
      log('_getAccount: ${e.message!}');
    }
    return null;
  }
}
