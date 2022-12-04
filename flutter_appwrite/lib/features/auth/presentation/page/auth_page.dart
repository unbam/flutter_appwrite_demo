import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../profile/presentation/page/profile_page.dart';
import '../notifier/auth_notifier.dart';

///
/// 認証ページ
///
class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Appwrite Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user == null ? '未ログイン' : 'ログイン済'),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('ユーザー作成'),
              onPressed: () async {
                authNotifier.create('test', 'unbamwork@gmail.com', 'password');
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('ドキュメント作成'),
              onPressed: () async {
                authNotifier.createDocumentUser();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('ログイン'),
              onPressed: () async {
                authNotifier.login('unbamwork@gmail.com', 'password');
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('ユーザー編集'),
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('ログアウト'),
              onPressed: () async {
                authNotifier.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
