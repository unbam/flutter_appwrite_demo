import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/presentation/notifier/auth_notifier.dart';

final _form = GlobalKey<FormState>();

///
/// プロフィールページ
///
class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final nameTextController = useTextEditingController(text: user?.name ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: user != null && user.iconUrl != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.iconUrl!),
                      )
                    : const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      ),
                onTap: () async {
                  log('onTap CircleAvatar');
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: nameTextController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                onChanged: (value) {
                  log('onChanged Name: $value');
                },
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: (() {
                  log('onPressed Save');
                  _form.currentState!.save();

                  if (user == null) {
                    return;
                  }

                  // TODO: 画像アップロード

                  // 名前変更
                  if (user.name != nameTextController.text) {
                    authNotifier.updateName(nameTextController.text);
                  }
                }),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
