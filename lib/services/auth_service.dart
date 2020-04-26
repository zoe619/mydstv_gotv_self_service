import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mydstv_gotv_self_service/models/tokens.dart';
import 'package:mydstv_gotv_self_service/utilities/constant.dart';
import 'package:flutter/services.dart';

class AuthService{


  final FirebaseAuth _auth = FirebaseAuth.instance;


//  getter to check if user is logged in or not and returns d appropriate stream
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  final FirebaseMessaging _messaging = FirebaseMessaging();

  Future<void> signUp(String name, String email, String password, String phone) async
  {
    try{
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if(authResult.user != null)
      {

        usersRef.document(authResult.user.uid)
            .setData({
          'name': name,
          'email': email,
          'phone': phone,
        });
        String token = await _messaging.getToken();
        tokensRef.document(authResult.user.uid)
           .setData({
          'device_token': token
        });

       try{
         authResult.user.sendEmailVerification();
       }
       catch(e){
         print("An error occured while trying to send email verification");
         print(e.message);
       }
      }
    }
    on PlatformException catch(err){
      throw(err);
    }
  }

  Future<bool> login(String email, String password) async {
    try{
      AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if(authResult.user.isEmailVerified)
      {
        return true;
      }
      else{
        return false;
      }

    }
    on PlatformException catch(err){
      throw (err);
    }
  }

  Future<void> sendPasswordReset(String email) async
  {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async
  {

    await removeToken();
    return Future.wait([
      _auth.signOut(),

    ]);
  }

  Future<void> removeToken() async
  {
    final currentUser = await _auth.currentUser();
    await tokensRef.document(currentUser.uid)
        .setData(
        {'device_token' : ''},
        merge: true
    );
  }

  Future<void> updateToken()async
  {
    final currentUser = await _auth.currentUser();
    final token  = await _messaging.getToken();
    final tokenDoc = await tokensRef.document(currentUser.uid).get();

    if(tokenDoc.exists)
    {
      Tokens tokenObj  = Tokens.fromDoc(tokenDoc);

      if(token != tokenObj.token){
        tokensRef
            .document(currentUser.uid)
            .setData({'device_token': token}, merge: true);
      }
    }

  }

}