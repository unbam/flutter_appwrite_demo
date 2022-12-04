import 'package:appwrite/appwrite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/constant.dart';

/// clientProvider
final clientProvider = Provider<MyClient>((ref) => MyClient()..init());

///
/// Appwrite Client
///
class MyClient {
  late Client client;

  ///
  /// 初期処理
  ///
  void init() {
    client = Client();
    client
        .setEndpoint(Constant.endpoint) // エンドポイント
        .setProject(Constant.projectId) // プロジェクトID
        .setSelfSigned();
  }
}
