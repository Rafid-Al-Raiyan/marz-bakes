import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marz_bakes/backend_services/auth_services.dart';
import 'package:marz_bakes/resuable_widget/icon.dart';
import 'package:marz_bakes/resuable_widget/utility.dart';
import 'package:marz_bakes/ui/admin/admin_home_page.dart';
import 'package:marz_bakes/ui/authentication/sign_in_page.dart';
import 'package:marz_bakes/ui/customer/home_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<String> adminEmails = [
    'cse_2012020024@lus.ac.bd',
    'crystalizedmeteorite@gmail.com',
    'marzbakes@gmail.com',
  ];

  AuthService authService = AuthService();
  FirebaseAuth auth = FirebaseAuth.instance;

  bool visibility = true;

  loginUser() async {
    final status = await authService.loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    // print(status);
    if (status == 'verified') {
      String email = auth.currentUser!.email!.toLowerCase();
      if (adminEmails.contains(email)) {
        Get.offAll(const AdminHomePage());
      } else {
        Get.offAll(const HomePage());
      }
    } else if (status == 'Not verified') {
      Get.defaultDialog(
          title: "Your account is not verified",
          middleText: "A verification link is sent to your email. Verify your account to log in.",
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("OK"),
            ),
          ]);
    } else {
      Get.snackbar(
        "Something went wrong",
        status.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  resetPassword() async {
    Get.bottomSheet(
      backgroundColor: Colors.white,
      Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.03),
            Text(
              "Enter your email and click on sent button to get password reset link.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: Get.textScaleFactor * 16),
              textAlign: TextAlign.center,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  label: Text("Email"),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.pinkAccent,
                  )),
            ),
            ElevatedButton(
              onPressed: () async {
                String response = await authService.resetPassword(emailController.text.trim());
                Get.back();
                if (response == 'success') {
                  Get.snackbar(
                    'Password Reset Email Sent',
                    'Check your email ${emailController.text}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else {}
              },
              child: const Text("Sent"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: color1,
        body: Container(
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const IconWidget(iconSize: 200),
                Divider(thickness: 2, color: color1),
                Text(
                  "Welcome to the MarzBakes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Get.textScaleFactor * 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(thickness: 2, color: color1),
                TextFormField(
                  controller: emailController,
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
                  controller: passwordController,
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: resetPassword,
                    child: const Text("Forget Password?"),
                  ),
                ),
                ElevatedButton(
                  onPressed: loginUser,
                  style: buttonStyle(),
                  child: const Text("Login"),
                ),
                SizedBox(height: Get.height * 0.02),
                OutlinedButton(
                  onPressed: () {
                    Get.off(const SignInPage());
                  },
                  style: buttonStyle(),
                  child: Text(
                    "Create Account",
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
    );
  }
}
