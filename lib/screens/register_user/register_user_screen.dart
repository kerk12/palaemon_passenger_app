import 'package:flutter/material.dart';
import 'package:palaemon_passenger_app/screens/register_user/widgets/registration_form.dart';

class RegisterUser extends StatelessWidget {
  static const String routeName = "register";
  const RegisterUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Palaemon Passenger App"),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  const Expanded(flex: 1, child: Text("")),
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: Image.asset(
                          'assets/images/palaemon_ship_logo.png'),
                    ),
                  ),
                ],
              )),
          Expanded(flex:3, child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/images/wave_transparent.png'),
                    fit: BoxFit.cover),
              ),
              child: RegisterUserForm()),)
        ]
      ),
    );
  }
}
