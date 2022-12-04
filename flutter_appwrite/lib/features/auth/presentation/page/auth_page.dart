import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifier/auth_notifier.dart';
import 'profile_page.dart';

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
              child: const Text('1. ユーザー作成'),
              onPressed: () async {
                authNotifier.create('test', 'test@example.com', 'password');
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('2. ドキュメント作成'),
              onPressed: () async {
                authNotifier.createDocumentUser();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('3. ログイン'),
              onPressed: () async {
                authNotifier.login('test@example.com', 'password');
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('4. ドキュメント読込'),
              onPressed: () async {
                authNotifier.getDocumentUser();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('5. ユーザー編集'),
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
              child: const Text('6. ログアウト'),
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
