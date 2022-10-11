import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/bloc/auth_bloc/auth_bloc.dart';

class RegisterUserForm extends StatelessWidget {
  final TextEditingController mumbleUserController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RegisterUserForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: mumbleUserController,
            validator: (value) {
          final valRegex = RegExp(r'^[a-zA-Z0-9_]{3,}$');
          final whitespaceRegex = RegExp(r"\W");
          return (value == null ||
                  value.isEmpty ||
                  !valRegex.hasMatch(value) ||
                  value.startsWith(whitespaceRegex) ||
                  value.endsWith("_"))
              ? "Please enter a valid user name."
              : null;
            },
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(Register(mumbleUserController.text));
              }
            },
            child: const Text("Register"),
          )
        ],
      ),
    );
  }
}
