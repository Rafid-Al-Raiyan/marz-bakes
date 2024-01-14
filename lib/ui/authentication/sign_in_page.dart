import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marz_bakes/backend_services/auth_services.dart';
import 'package:marz_bakes/backend_services/firestore_services.dart';
import 'package:marz_bakes/ui/authentication/log_in_page.dart';

import '../../resuable_widget/icon.dart';
import '../../resuable_widget/utility.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final fullNameRegex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
  final phoneRegex = RegExp(r'^01[3-9]\d{8}$');
  final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{6,}$');

  final form = GlobalKey<FormState>();
  AuthService authService = AuthService();
  FireStoreService fireStoreService = FireStoreService();
  bool visibility = true;

  createAccount() async {
    final Map<String, dynamic> user = {
      "Name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": numberController.text.trim(),
    };
    bool status = await authService.createUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    // print(status);
    if (status) {
      await fireStoreService.addUserData(user);
      Get.defaultDialog(
        title: "Your account created successfully",
        middleText: "A verification link is sent to your email. Verify your account to log in.",
        actions: [
          TextButton(
            onPressed: () {
              Get.off(const LogInPage());
            },
            child: const Text("OK"),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: color1,
        body: Container(
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const IconWidget(iconSize: 140),
                  Divider(thickness: 2, color: color1),
                  Text(
                    "Welcome to the MarzBakes",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: Get.textScaleFactor * 20),
                    textAlign: TextAlign.center,
                  ),
                  Divider(thickness: 2, color: color1),
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Please enter your name.";
                      } else if (fullNameRegex.hasMatch(value.trim()) == false) {
                        return "Name is not formatted well.";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text("Full Name"),
                      prefixIcon: Icon(
                        Icons.person,
                        color: color1,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.01),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Please enter your email.";
                      } else if (emailRegex.hasMatch(value.trim()) == false) {
                        return "Email is not formatted well.";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text("Email"),
                      prefixIcon: Icon(
                        Icons.email,
                        color: color1,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.01),
                  TextFormField(
                    controller: numberController,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Please enter your number.";
                      } else if (phoneRegex.hasMatch(value.trim()) == false) {
                        return "Number is not formatted well.";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: const Text("Phone"),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: color1,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.01),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Please enter your password.";
                      } else if (passwordRegex.hasMatch(value.trim()) == false) {
                        return "Password length must 6 with one uppercase, lowercase & digit.";
                      }
                      return null;
                    },
                    obscureText: visibility,
                    decoration: InputDecoration(
                      label: const Text("Password"),
                      suffixIcon: IconButton(
                        icon: visibility
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            visibility = !visibility;
                          });
                        },
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: color1,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.01),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: visibility,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "Please enter your password.";
                      } else if (value.trim() != passwordController.text.trim()) {
                        return "Password not matched.";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: const Text("Re-type Password"),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: color1,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      if (form.currentState!.validate()) {
                        createAccount();
                      }
                    },
                    style: buttonStyle(),
                    child: const Text("Create Account"),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  OutlinedButton(
                    onPressed: () {
                      Get.off(const LogInPage());
                    },
                    style: buttonStyle(),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: Get.textScaleFactor * 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
