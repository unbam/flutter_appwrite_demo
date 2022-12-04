import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../notifier/auth_notifier.dart';

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
    final iconFile = useState<XFile?>(null);

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
                child: FutureBuilder<Uint8List?>(
                    future: authNotifier.getIcon(),
                    builder: (context, snapshot) {
                      if (iconFile.value != null) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              Image.file(File(iconFile.value!.path)).image,
                        );
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage: Image.memory(snapshot.data!).image,
                        );
                      } else {
                        return const CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person, size: 50),
                        );
                      }
                    }),
                onTap: () async {
                  log('onTap CircleAvatar');
                  final picker = ImagePicker();
                  final image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    iconFile.value = image;
                  }
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
                  if (user == null) {
                    return;
                  }

                  _form.currentState!.save();

                  // 画像アップロード
                  if (iconFile.value != null) {
                    authNotifier.updateIcon(
                        iconFile.value!.path, iconFile.value!.name);
                  }

                  // 名前変更
                  if (user.name != nameTextController.text) {
                    authNotifier.updateName(nameTextController.text);
                  }
                }),
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
