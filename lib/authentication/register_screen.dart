

import 'package:flutter/material.dart';

import 'custom_form_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  Future<void> signup() async {

  }

  Future<void> getCurrentLocation() async {

  }

  Future<void> _getImage() async {

  }

  List<Widget> _getTextFields() {
    return [
      CustomFormTextField(
        controller: nameController,
        iconData: Icons.person,
        hintText: "Name",
      ),
      CustomFormTextField(
        controller: emailController,
        iconData: Icons.email,
        hintText: "Email",
      ),
      CustomFormTextField(
        controller: passwordController,
        iconData: Icons.lock,
        hintText: "Password",
        obscureText: true,
      ),
      CustomFormTextField(
        controller: confirmPasswordController,
        iconData: Icons.lock,
        hintText: "Confirm Password",
        obscureText: true,
      ),
      CustomFormTextField(
        controller: phoneController,
        iconData: Icons.phone,
        hintText: "Phone",
      ),
      CustomFormTextField(
        controller: locationController,
        iconData: Icons.my_location,
        hintText: "Address",
      ),
      _getLocationButton(),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: _getElevatedButton(),
      ),
    ];
  }

  ElevatedButton _getElevatedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          minimumSize: const Size.fromHeight(50)),
      onPressed: signup,
      child: const Text(
        "Sign Up",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _getLocationButton() {
    return Container(
      width: 400,
      height: 40,
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        onPressed: getCurrentLocation,
        icon: const Icon(
          Icons.location_on,
          color: Colors.white,
        ),
        label: const Text(
          "Get my Current Location",
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: _getTextFields(),
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