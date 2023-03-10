import 'package:flutter/material.dart';
import 'package:riders_app/home_screen/home_screen.dart';
import 'package:riders_app/services/user_services.dart';
import 'package:riders_app/validation/validation.dart';
import 'package:riders_app/widgets/custom_form_text_field.dart';
import 'package:riders_app/widgets/show_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      showLoadingDialog(context, 'Authenticating...');
      await loginUser(emailController.text, passwordController.text).then((value) {
        Navigator.pop(context);
        Navigator.push(
              context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }).catchError((error) {
        Navigator.pop(context);
        showErrorDialog(context, error.toString());
      });
    }
  }

  Widget _getDpImage() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Image.asset(
          "images/signup.png",
          height: 270,
        ),
      ),
    );
  }

  ElevatedButton _getElevatedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          minimumSize: const Size.fromHeight(50)),
      onPressed: login,
      child: const Text(
        "Login",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _getDpImage(),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomFormTextField(
                  controller: emailController,
                  iconData: Icons.email,
                  hintText: "Email",
                  validator: validateEmailField,
                ),
                CustomFormTextField(
                  controller: passwordController,
                  iconData: Icons.lock,
                  hintText: "Password",
                  obscureText: true,
                  validator: validatePassword,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _getElevatedButton(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
