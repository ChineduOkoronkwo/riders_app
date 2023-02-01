import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riders_app/home_screen/home_screen.dart';
import 'package:riders_app/services/location_service.dart';
import 'package:riders_app/services/user_services.dart';
import 'package:riders_app/validation/validation.dart';
import 'package:riders_app/widgets/custom_form_text_field.dart';
import 'package:riders_app/widgets/show_dialog.dart';

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

  XFile? imageXFile;
  final ImagePicker _imagePicker = ImagePicker();
  Position? position;

  Future<void> _getImage() async {
    imageXFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  Future<void> signup() async {
    if (isValidImage() && _formKey.currentState!.validate()) {
      showLoadingDialog(context, "Processing...");
      await uploadImage(imageXFile!.path).then((imageUrl) async {
        var user =
            await createSeller(emailController.text, passwordController.text);
        await saveUserData(user.uid, emailController.text, nameController.text,
            imageUrl, phoneController.text, locationController.text, position!);
        await setUserDataLocally(user.uid);
      }).then((value) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }).catchError((error) {
        Navigator.pop(context);
        // Ideally, error should be pushed to a remote server.
        // For now will show the error.
        showErrorDialog(context, error.toString());
      });
    }
  }

  Future<void> getCurrentLocation() async {
    position = await getCurrentLocationPosition();
    locationController.text = await getCurrentLocationAddress(position!);
  }

  String? validateConfirmPass(String? value) {
    return validateConfirmPassword(value, passwordController.text);
  }

  bool isValidImage() {
    if (imageXFile == null) {
      showErrorDialog(context, "Please select an image!");
      return false;
    }
    return true;
  }

  List<Widget> _getTextFields() {
    return [
      CustomFormTextField(
        controller: nameController,
        iconData: Icons.person,
        hintText: "Name",
        validator: validateNameField,
      ),
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
      CustomFormTextField(
        controller: confirmPasswordController,
        iconData: Icons.lock,
        hintText: "Confirm Password",
        obscureText: true,
        validator: validateConfirmPass,
      ),
      CustomFormTextField(
        controller: phoneController,
        iconData: Icons.phone,
        hintText: "Phone",
        validator: validatePhoneField,
      ),
      CustomFormTextField(
        controller: locationController,
        iconData: Icons.my_location,
        hintText: "Current Address",
        validator: validateAddressField,
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

  InkWell _getImagePicker() {
    return InkWell(
        onTap: _getImage,
        child: CircleAvatar(
          radius: MediaQuery.of(context).size.width * 0.20,
          backgroundColor: Colors.white,
          backgroundImage:
              imageXFile == null ? null : FileImage(File(imageXFile!.path)),
          child: _getImageIcon(context),
        ));
  }

  Widget? _getImageIcon(BuildContext context) {
    if (imageXFile == null) {
      return Icon(
        Icons.add_photo_alternate,
        size: MediaQuery.of(context).size.width * 0.20,
        color: Colors.grey,
      );
    }
    return null;
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
          _getImagePicker(),
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
