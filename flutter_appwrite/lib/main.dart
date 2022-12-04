import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'features/auth/presentation/notifier/auth_notifier.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
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
              Text(user?.name ?? 'No User'),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: const Text('ユーザー作成'),
                onPressed: () async {
                  authNotifier.create('test', 'test@example.com', 'password');
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: const Text('ログイン'),
                onPressed: () async {
                  authNotifier.login('test@example.com', 'password');
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
      ),
    );
  }
}
