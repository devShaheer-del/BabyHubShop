import 'package:babyshop_hub/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  String _selectedRole = "Mother"; // Default selected value

  final _formKey = GlobalKey<FormState>();

  void handelSignup() async {
    if (_formKey.currentState!.validate()) {
      // this user create function
      final name = _name.text.trim();
      final phone = _phone.text.trim();
      final email = _email.text.trim();
      final password = _password.text.trim();

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'role': _selectedRole, // Save the selected role (Mother or Father)
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User was successfully Created")));

      print("Signup Successful");
    } else {
      print("Form validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 98, 150),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text("Signup"),
        actions: [Icon(Icons.more_vert_outlined)],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 300,
                child: Image.asset(
                  '../../assets/images/caring.png',
                  height: 220,
                ),
              ),
              Container(
                width: 300,
                child: TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.person_2_outlined),
                    hintText: "Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                width: 300,
                child: TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.phone_android_outlined),
                    hintText: "Phone",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number is required";
                    } else if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                      return "Enter a valid 11-digit phone number";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                width: 300,
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.email_outlined),
                    hintText: "Email",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                width: 300,
                child: TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.password_outlined),
                    hintText: "Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters long";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 14),
              Container(
                width: 300,
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  items: ["Mother", "Father"].map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    // hintText: "Relation With Child",
                    label: Text("Relation with Child"),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              SizedBox(height: 14),
              Container(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: handelSignup,
                  child: Text(
                    "Signup",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 98, 150),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "I already have an Account",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
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
