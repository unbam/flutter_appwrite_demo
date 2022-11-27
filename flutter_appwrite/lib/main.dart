import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Appwrite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Client client;
  @override
  void initState() {
    super.initState();

    client = Client();
    client
        .setEndpoint('https://localhost/v1')
        .setProject('6382ed28b21dddbfac79')
        .setSelfSigned();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Appwrite Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  final account = Account(client);

                  final user = await account.create(
                      userId: ID.unique(),
                      email: 'test@example.com',
                      password: 'password',
                      name: 'Demo User');

                  debugPrint(user.status.toString());
                } on AppwriteException catch (e) {
                  debugPrint(e.message);
                }
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
