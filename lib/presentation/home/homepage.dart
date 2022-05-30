import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneybag/application/auth/auth_provider.dart';
import 'package:moneybag/application/auth/auth_state.dart';
import 'package:moneybag/domain/app/user_profile.dart';
import 'package:moneybag/presentation/home/auth/login_page.dart';

class Homepage extends ConsumerWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final profile = ref.watch(authProvider.select((value) => value.profile));

    ref.listen<AuthState>(authProvider, ((previous, next) {
      if (previous!.profile != next.profile &&
          next.profile == UserProfile.empty()) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const LoginPage()));
      }
    }));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Hello"),
          const SizedBox(height: 20),
          Text(profile.name, style: Theme.of(context).textTheme.headline4),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            ref.read(authProvider.notifier).logout();
          },
          label: const Text("Logout")),
    );
  }
}
