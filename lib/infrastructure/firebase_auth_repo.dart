import 'package:clean_api/clean_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Source;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moneybag/domain/app/source.dart';
import 'package:moneybag/domain/app/user_profile.dart';
import 'package:moneybag/domain/auth/i_auth_repo.dart';
import 'package:moneybag/domain/auth/signup_body.dart';
import 'package:moneybag/domain/auth/login_body.dart';

class FirebaseAuthRepo extends IAuthRepo {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  @override
  TaskEither<CleanFailure, UserProfile> login(LoginBody loginBody) =>
      TaskEither.tryCatch(() async {
        final loginResponse = await auth.signInWithEmailAndPassword(
            email: loginBody.email, password: loginBody.password);

        if (loginResponse.user != null) {
          final data = await db
              .collection('users')
              .doc(loginResponse.user!.uid)
              .get()
              .then((value) => value.data());

          if (data != null) {
            final profile = UserProfile.fromMap(data);
            return profile;
          } else {
            throw 'Profile data was not found.';
          }
        } else {
          throw 'Login is unsuccesfull, something went wrong!';
        }
      }, (error, _) => CleanFailure(tag: "login", error: error.toString()));

  @override
  TaskEither<CleanFailure, UserProfile> registration(SignupBody signupBody) =>
      TaskEither.tryCatch(
        (() async {
          final registerResponse = await auth.createUserWithEmailAndPassword(
              email: signupBody.email, password: signupBody.password);

          if (registerResponse.user != null) {
            final userProfile = UserProfile(
                name: signupBody.name,
                id: registerResponse.user!.uid,
                email: signupBody.email,
                sources: [Source(name: "cash", createdAt: DateTime.now())]);

            await db
                .collection('users')
                .doc(registerResponse.user!.uid)
                .set(userProfile.toMap());

            return userProfile;
          } else {
            throw 'Registration is unsuccesfull. something went wrong.';
          }
        }),
        ((error, _) =>
            CleanFailure(tag: "Registration", error: error.toString())),
      );

  @override
  TaskEither<CleanFailure, UserProfile> checkAuth() =>
      TaskEither.tryCatch(() async {
        final user = auth.currentUser;
        if (user != null) {
          final data = await db
              .collection('users')
              .doc(user.uid)
              .get()
              .then((value) => value.data());

          if (data != null) {
            final profile = UserProfile.fromMap(data);
            return profile;
          } else {
            throw 'Profile data was not found.';
          }
        } else {
          throw 'you are not logged in';
        }
      },
          (error, _) =>
              CleanFailure(tag: "Check Auth", error: error.toString()));

  @override
  Future<void> logout() async {
    await auth.signOut();
  }
}
