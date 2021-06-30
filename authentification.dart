abstract class AuthImplementation 
{
    Future<String> SignIn(String email , Sting password) ;
    Future<String> SignUp(String email , Sting password) ;
    Future<void> signOut() ;
    Future<String> getCurrentUser() ; 
}

class Auth implements AuthImplemetation 
{  
Final FirebaseAuth _firebaseAuth = FirebaseAuth.instance ; 
// Methode pour le Signin //
Future<String> SignIn(String email , Sting password) async 
{
  FirebaseUser user = await _firebaseAuth.signInwithEmailAndPassword( email : email , password :password ); 
  return user.uid ;
}
// Methode pour le Signup //
Future<String> SignUp(String email , Sting password) async 
{
  FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword( email : email , password :password ); 
  return user.uid ;
}
// Logout the user // 
 Future<void> signOut() async 
{ 
  _firebaseAuth.signOut();
}
// savoir l'utlilisateur logué au moment réel // 

Future<String> getCurrentUser() async 
{ 
  FirebaseUser user = await  _firebaseAuth.currentUser(); 
return user.uid ;
}
    
}
