import 'package:clean_api/clean_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneybag/application/auth/auth_provider.dart';
import 'package:moneybag/application/auth/auth_state.dart';
import 'package:moneybag/domain/app/user_profile.dart';
import 'package:moneybag/presentation/home/auth/login_page.dart';
import 'package:moneybag/presentation/home/homepage.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 100), (() {
        ref.read(authProvider.notifier).checkAuth();
      }));
    }, []);

    ref.listen<AuthState>(authProvider, ((previous, next) {
      if (previous != next && !next.loading) {
        if (next.failure != CleanFailure.none() ||
            next.profile == UserProfile.empty()) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: ((context) => const LoginPage())));
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: ((context) => const Homepage())));
        }
      }
    }));

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Wallet",
              style: TextStyle(fontSize: 40, color: Colors.deepPurple),
            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
