import 'package:flutter/material.dart';
import 'package:palaemon_passenger_app/screens/register_user/widgets/registration_form.dart';

class RegisterUser extends StatelessWidget {
  static const String routeName = "register";
  const RegisterUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Container()),
          Expanded(child: RegisterUserForm(),)
        ]
      ),
    );
  }
}
