import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bydelivery/models/usuario.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_options.dart';

class Authentication {
  static Usuario? user;
  static final List<String> _scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];
  static late GoogleSignIn _googleSignIn;
  static late final FirebaseAuth _auth;
  static late FirebaseApp _app;
  // ignore: constant_identifier_names
  static const URL_HOST_API = "http://192.168.1.8:5001";
  // ignore: constant_identifier_names
  static const SERVICE = "login";

  static Future<void> login(String email, String senha) async {
    try {
      // converte a senha limpa em SHA256
      // senha: 123456 => (em SHA256) 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
      Uint8List utf8Bytes = Uint8List.fromList(utf8.encode(senha));
      Digest digest = sha256.convert(utf8Bytes);
      senha = digest.toString();
      final resposta =
          await http.get(Uri.parse("$URL_HOST_API/$SERVICE/$email/$senha"));
      final Usuario usuario = Usuario.fromJson(jsonDecode(resposta.body)[0]);
      user = usuario;
    } catch (e) {
      user = null;
    }
  }

  static Future<void> loginWithGoogle() async {
    _app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _googleSignIn = GoogleSignIn(
        // Optional clientId
        // clientId: 'your-client_id.apps.googleusercontent.com',
        scopes: _scopes,
        clientId: _app.options.androidClientId);
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
    GoogleSignInAccount? _currentUser;
    bool _isAuthorized = false; // has granted permissions?
    String _contactText = '';

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;
      // However, in the web...
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(_scopes);
      }

      _currentUser = account;
      _isAuthorized = isAuthorized;

      // Now that we know that the user can access the required scopes, the app
      // can call the REST API.
      if (isAuthorized) {
        print("Não autorizado");
      }
    });

    // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
    //
    // It is recommended by Google Identity Services to render both the One Tap UX
    // and the Google Sign In button together to "reduce friction and improve
    // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
    // _googleSignIn.signInSilently();
    // try {
    //   final GoogleSignInAccount? googleSignInAccount =
    //       await _googleSignIn.signInSilently();
    //   final GoogleSignInAuthentication? googleSignInAuthentication =
    //       await googleSignInAccount?.authentication;

    //   final AuthCredential credential = GoogleAuthProvider.credential(
    //       accessToken: googleSignInAuthentication?.accessToken,
    //       idToken: googleSignInAuthentication?.idToken);

    //   final UserCredential userCredential =
    //       await _auth.signInWithCredential(credential);
    //   final User? userGoogle = userCredential.user;

    //   if (userGoogle != null) {
    //     user = Usuario(userGoogle.uid as int, userGoogle.photoURL!,
    //         userGoogle.displayName!, userGoogle.email!, "");
    //     print("Usuário fez login pela conta Google.");
    //   }
    // } catch (e) {
    //   print('Erro ao fazer login: $e');
    // }

    try {
      if (_currentUser != null) {
        user = Usuario(_currentUser?.id as int, _currentUser!.photoUrl!,
            _currentUser!.displayName!, _currentUser!.email, "");
        print("Usuário fez login pela conta Google.");
      }
    } catch (e) {
      print('Erro ao fazer login: $e');
    }
  }

  static bool isLoggedIn() {
    return user == null ? false : true;
  }

  // static Future<void> handleSignIn() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //     print('teste');
  //     if (googleUser == null) {
  //       // O usuário cancelou o login.
  //       return;
  //     }
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     user?.avatar =
  //         (googleUser.photoUrl!.isNotEmpty ? googleUser.photoUrl : "")!;
  //     user?.email = googleUser.email;
  //     user?.nome =
  //         (googleUser.displayName!.isNotEmpty ? googleUser.displayName : "")!;
  //     user?.id = googleUser.id as int;
  //     print('ID Token: ${googleAuth.idToken}');
  //     print('Access Token: ${googleAuth.accessToken}');
  //     print('Nome: ${user?.nome}');
  //     print('Email: ${user?.email}');
  //     print('Avatar: ${user?.avatar}');
  //     print('Id: ${user?.id}');
  //     // ignore: use_build_context_synchronously
  //   } catch (error) {
  //     print('Erro ao fazer login: $error');
  //   }
  // }

  static Future<void> logout() async {
    user = null;
    if (_auth.currentUser!.uid.isNotEmpty) {
      await GoogleSignIn().signOut();
      print("Usuário fez logout da conta Google.");
      return;
    }
    print("Usuário fez logout do App.");
  }

  // Future<void> initFirebase() async {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }
}
