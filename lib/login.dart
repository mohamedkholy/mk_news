import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() {
    return MyState();
  }
}

class MyState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  var loading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Registration",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, right: 40, left: 40),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: "Email"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            else if(!value.contains("@")){
                              return 'email must contain @';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: TextFormField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: passwordController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            else if(value.length < 8){
                              return 'password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            loading?CircularProgressIndicator(color: Colors.black,):Container(),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          loading=true;
                          setState(() {

                          });
                          _auth.createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text).then((value){
                                if(value.user!=null){
                                Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Home(),
                              ));}
                                else{
                                  loading=false;
                                  setState(() {

                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('login failed')),
                                  );

                                }
                              }
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill input')),
                          );
                        }
                      },
                      child: Text("Sign Up"),
                      color: Colors.cyan,
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          loading=true;
                          setState(() {

                          });
                          _auth.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text).then((value){
                            if(value.user!=null){
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const Home(),
                                  ));}
                            else{
                              loading=false;
                              setState(() {

                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('login failed')),
                              );

                            }
                          }
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill input')),
                          );
                        }
                      },
                      child: Text("Login"),
                      color: Colors.green,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
