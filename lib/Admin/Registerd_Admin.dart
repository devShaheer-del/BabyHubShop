import 'package:babyshop_hub/CustomeWidget/SideDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterdAdmin extends StatefulWidget {
  const RegisterdAdmin({super.key});

  @override
  State<RegisterdAdmin> createState() => _RegisterdAdminState();
}

class _RegisterdAdminState extends State<RegisterdAdmin> {
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  String _selectedRole = "Admin"; // Default selected value

  final _formKey = GlobalKey<FormState>();

    void handelAdminRegisterd() async {
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
          SnackBar(content: Text("Admin Created Successfully")));

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
        title: Text("Create Admin"),
      ),
      drawer: Sidedrawer(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
            child: Column(
              children: [
                Container(
                  width: 300,
                  child: Image.asset(
                    '../../assets/images/admin.png',
                    height: 220,
                  ),
                ),

                SizedBox(height: 12,),
                Container(
                  width: 300,
                  child: TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person_2_outlined),
                      hintText: "Authorized Name",
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
                      hintText: "Authorized Phone",
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
                      hintText: "Authorized Email",
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
                      hintText: "Authorized Password",
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
                    items: ["Admin", "Seller"].map((String role) {
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
                    onPressed: handelAdminRegisterd,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
