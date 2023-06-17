import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../controllers/user_controller.dart';
import '../models/web_styles.dart' as web;
import 'dashboard/components/palate.dart';
import 'dashboard/components/sized_box.dart';
import 'dashboard/components/text_field.dart' as txt_field;
import 'logo.dart';
class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        textTheme: Theme.of(context).textTheme.copyWith(
              labelMedium: web.labelMedium(color: Palate.black.withOpacity(0.5)),
              headlineMedium: TextStyle(
                color: Palate.sand, // Set sign-in text color to Palate.sand
              ),
              
            ),
      ),
      child: Scaffold(
        backgroundColor: Palate.black,
        body: Padding(
          padding: EdgeInsets.only(top: 150, right: 30, left: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Logo().logo(),
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      emailField(),
                      Sized_Box().sizedBoxH(context, 30),
                      passwordField(context),
                      submitButton(context),
                      Sized_Box().sizedBoxH(context, 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column passwordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 460,
          child: txt_field.CustomTextField(
            type: txt_field.Type.password,
            controller: passwordController,
            hint: "Password",
            lable: "Password",
            forWhat: txt_field.For.signin,
             
          ),
        ),
        Sized_Box().sizedBoxH(context, 7),
         
      ],
    );
  }

  Container emailField() {
    return Container(
      width: 460,
      child: txt_field.CustomTextField(
        type: txt_field.Type.email,
        controller: emailController,
        hint: "Email",
        lable: "Email",
        forWhat: txt_field.For.signin,
        
      ),
    );
  }

  Padding submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Container(
        height: 60,
        width: kIsWeb ? 200 : 260, // Adjust button width for desktop view
        child: ElevatedButton(
          onPressed: () {
            onPress(context);
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
              Palate.lighterBlack.withOpacity(0.48),
            ),
          ),
          child: Text(
            "Sign In",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }

  onPress(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;
      print("before");
      UserController().signin(email, password).then((value) {
        print("during");
        Navigator.pushNamed(context, "/main_screen");
      }).catchError((ex, stacktrace) {
        print("error");
        print(ex.toString());
        print(stacktrace);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("This is my content"),
          ),
        );
      });
    }
  }
}
