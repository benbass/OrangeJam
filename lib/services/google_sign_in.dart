import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class SignInToGoogle{
  Future<void>? _initialization;

  Future<void> _ensureInitialized() {
    return _initialization ??=
    GoogleSignInPlatform.instance.init(const InitParameters())
      ..catchError((dynamic _) {
        _initialization = null;
      });
  }

  Future<GoogleSignInUserData?> signIn() async {
    await _ensureInitialized();
    try {
      final AuthenticationResults? result = await GoogleSignInPlatform.instance
          .attemptLightweightAuthentication(
          const AttemptLightweightAuthenticationParameters());
      GoogleSignInUserData? currentUser = result?.user;
      return currentUser;
    } on GoogleSignInException {
      rethrow;
    }
  }

  Future<GoogleSignInUserData?> handleSignIn() async {
    try {
      await _ensureInitialized();
      final AuthenticationResults result = await GoogleSignInPlatform.instance
          .authenticate(const AuthenticateParameters());
      GoogleSignInUserData? currentUser = result.user;
      return currentUser;
    } on GoogleSignInException catch (e) {
      String errorMessage = e.code == GoogleSignInExceptionCode.canceled
          ? ''
          : 'GoogleSignInException ${e.code}: ${e.description}';
      throw Exception(errorMessage);
    }
  }


}