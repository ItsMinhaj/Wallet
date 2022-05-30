import 'package:clean_api/clean_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moneybag/application/auth/auth_provider.dart';
import 'package:moneybag/domain/auth/login_body.dart';
import 'package:moneybag/presentation/home/auth/registration.dart';
import 'package:moneybag/presentation/home/auth/utils/validation_rules.dart';
import 'package:moneybag/presentation/home/homepage.dart';

import '../../../application/auth/auth_state.dart';
import '../../../domain/app/user_profile.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final showPassword = useState(false);
    final formkey = useMemoized((() => GlobalKey<FormState>()));

    final state = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, ((previous, next) {
      if (previous != next && !next.loading) {
        if (next.failure != CleanFailure.none() ||
            next.profile == UserProfile.empty()) {
          if (next.failure != CleanFailure.none()) {
            Logger.e(next.failure);
            CleanFailureDialogue.show(context, failure: next.failure);
          }
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: ((context) => const Homepage())));
        }
      }
    }));

    return Scaffold(
      body: state.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Form(
                key: formkey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 160, bottom: 50),
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: ValidationRules.email,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        enabled: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      validator: ValidationRules.password,
                      obscureText: !showPassword.value,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffix: InkWell(
                            onTap: () {
                              showPassword.value = !showPassword.value;
                            },
                            child: showPassword.value
                                ? const Icon(Icons.remove_red_eye,
                                    color: Colors.green)
                                : const Icon(
                                    Icons.visibility_off_rounded,
                                    color: Colors.grey,
                                  )),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        enabled: true,
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState?.validate() ?? false) {
                            ref.read(authProvider.notifier).login(LoginBody(
                                email: emailController.text,
                                password: passwordController.text));
                          }
                        },
                        child: const Text("Login")),
                    const SizedBox(height: 20),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Registration()));
                        },
                        child: const Text("Signup")),
                  ],
                ),
              ),
            ),
    );
  }
}
