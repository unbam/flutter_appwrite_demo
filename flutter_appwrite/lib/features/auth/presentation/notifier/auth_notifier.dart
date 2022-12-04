import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/constant.dart';
import '../../../../utils/my_client.dart';
import '../../data/model/user.dart';

/// authNotifierProvider
final authNotifierProvider =
    StateNotifierProvider.autoDispose<AuthNotifier, User?>(
  (ref) => AuthNotifier(ref.read(clientProvider))..init(),
);

///
/// AuthNotifier
///
class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier(this._myClient) : super(null);

  final MyClient _myClient;
  late Account account;
  late Databases databases;
  late Storage storage;
  late String _sessionId;

  ///
  /// 初期処理
  ///
  void init() {
    account = Account(_myClient.client);
    databases = Databases(_myClient.client);
    storage = Storage(_myClient.client);
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

      log('create: success');
      log(result.toMap().toString());
    } on AppwriteException catch (e) {
      log('create: ${e.message!}');
    }
  }

  ///
  /// ユーザーのドキュメント作成
  ///
  Future<void> createDocumentUser() async {
    if (state == null) {
      return;
    }

    try {
      final document = await databases.createDocument(
        databaseId: Constant.databaseId,
        collectionId: Constant.userCollectionId,
        documentId: state!.id,
        data: {
          'iconFileId': null,
        },
      );

      log('createUser: success');
      log(document.toMap().toString());
    } on AppwriteException catch (e) {
      log('createUser: ${e.message!}');
    }
  }

  ///
  /// ユーザーのドキュメント読込
  ///
  Future<void> getDocumentUser() async {
    if (state == null) {
      return;
    }

    try {
      final document = await databases.getDocument(
        databaseId: Constant.databaseId,
        collectionId: Constant.userCollectionId,
        documentId: state!.id,
      );

      log('getDocumentUser: success');
      log(document.toMap().toString());

      state = state!.copyWith(iconFileId: document.data['iconFileId']);
    } on AppwriteException catch (e) {
      log('getDocumentUser: ${e.message!}');
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
      _sessionId = result.$id;
      state = await _getAccount();

      log('login: success');
      log(result.toMap().toString());
    } on AppwriteException catch (e) {
      log('login: ${e.message!}');
    }
  }

  ///
  /// ログアウト
  ///
  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: _sessionId);
      state = null;
      log('logout: success');
    } on AppwriteException catch (e) {
      log('logout: ${e.message!}');
    }
  }

  ///
  /// アカウント名変更
  /// @param name: ユーザー名
  ///
  Future<void> updateName(String name) async {
    try {
      final result = await account.updateName(name: name);
      state = User.fromJson(result.toMap());
      log('updateName: success');
      log(result.toMap().toString());
    } on AppwriteException catch (e) {
      log('updateName: ${e.message!}');
    }
  }

  ///
  /// アイコン変更
  /// @param originalIconUrl: アイコンURL
  /// @param fileName: ファイル名
  ///
  Future<void> updateIcon(String originalIconUrl, String fileName) async {
    try {
      final result = await storage.createFile(
        bucketId: Constant.bucketId,
        fileId: ID.unique(),
        file: InputFile(path: originalIconUrl, filename: fileName),
      );
      log('updateIconUrl createFile: success');
      log(result.toMap().toString());

      state = state?.copyWith(iconFileId: result.$id);

      await databases.updateDocument(
        databaseId: Constant.databaseId,
        collectionId: Constant.userCollectionId,
        documentId: state!.id,
        data: {
          'iconFileId': result.$id,
        },
      );
      log('updateIcon updateDocument: success');
    } on AppwriteException catch (e) {
      log('updateIcon: ${e.message!}');
    }
  }

  ///
  /// アイコン取得
  ///
  Future<Uint8List?> getIcon() async {
    if (state == null || state!.iconFileId == null) {
      return null;
    }

    final storage = Storage(_myClient.client);
    final result = await storage.getFileDownload(
      bucketId: Constant.bucketId,
      fileId: state!.iconFileId!,
    );

    return result;
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
