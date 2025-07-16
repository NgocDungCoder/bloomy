import 'package:bloomy/controllers/album_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../routes/route.dart';
import '../widgets/snackbar.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final isAuth = false.obs;

// create googleSignIn instance
  final googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'profile',
      // Nếu app cần quyền khác, ví dụ đọc danh bạ:
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

// method to sign in using google
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      // Check if user cancelled the sign in
      if (googleSignInAccount == null) {
        return false; // User cancelled
      }

      // get authentication tokens
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // create a firebase credential using the tokens from google
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // sign in to firebase using the google credential
      await auth.signInWithCredential(authCredential);
      isAuth.value = true;
      return true; // Sign-in successful
    } on FirebaseAuthException catch (e) {
      print(e
          .toString()); // Don't invoke 'print' in production code. Try using a logger.
      isAuth.value = false;

      return false; // Error occurred
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      isAuth.value = true;
      return true;
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      isAuth.value = false;
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      // Tạo tài khoản
      await auth.createUserWithEmailAndPassword(email: email, password: password);

      final user = auth.currentUser;

      if (user != null) {
        // 🧠 Cắt tên từ email
        final displayName = email.split('@')[0];

        // 📸 Lấy ảnh ngẫu nhiên từ danh sách
        // final imageAssets = List.generate(164, (index) => 'assets/images/img${index + 1}.jpg');
        // imageAssets.shuffle();
        // final avatarAsset = imageAssets.first;
        //
        // // 🖼️ Đổi đường dẫn thành kiểu Firebase Storage giả định (tuỳ cấu trúc bạn đang dùng)
        // final avatarURL = 'https://firebasestorage.googleapis.com/v0/b/your-app-id.appspot.com/o/$avatarAsset?alt=media';

        // ✍️ Cập nhật tên & ảnh lên Firebase Auth
        await user.updateDisplayName(displayName);
        // await user.updatePhotoURL(avatarURL);

        // ✅ Reload lại để cập nhật
        await user.reload();
      }

      return true;
    } catch (e) {
      print("Lỗi đăng ký: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      // Đăng xuất khỏi Firebase
      await auth.signOut();

      // Kiểm tra nếu đang đăng nhập Google
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect(); // Xoá token Google
        await googleSignIn.signOut();    // Đăng xuất Google
      }

      isAuth.value = false; // Cập nhật trạng thái
      showCustomSnackbar(message: "Logout success !");
      print("Đăng xuất thành công.");
    } catch (e) {
      print("Lỗi khi đăng xuất: $e");
      showCustomSnackbar(message: "Logout failed !", type: SnackbarType.warning);

    }
  }


  User? getCurrentUser() {
    return auth.currentUser;
  }

  // ✅ Hàm lấy thông tin cụ thể
  Map<String, String?> getUserProfile() {
    final user = auth.currentUser;

    if (user != null) {
      return {
        'displayName': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
        'uid': user.uid,
      };
    } else {
      return {
        'displayName': null,
        'email': null,
        'photoURL': null,
        'uid': null,
      };
    }
  }
}
