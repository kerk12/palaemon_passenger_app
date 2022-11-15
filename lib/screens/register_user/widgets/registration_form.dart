import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palaemon_passenger_app/bloc/auth_bloc/auth_bloc.dart';

class RegisterUserForm extends StatelessWidget {
  final TextEditingController mumbleUserController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RegisterUserForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
          MediaQuery.of(context).size.width * 0.05,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: mumbleUserController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Enter your ticket number',
                  labelStyle: const TextStyle(
                    color: Colors.black54,
                     fontSize: 17,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      width: 2,
                      style: BorderStyle.none,
                    ),
                  ),
                  focusColor: Colors.black,
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                validator: (value) {
              final valRegex = RegExp(r'^[a-zA-Z0-9_]{3,}$');
              final whitespaceRegex = RegExp(r"\W");
              return (value == null ||
                      value.isEmpty ||
                      !valRegex.hasMatch(value) ||
                      value.startsWith(whitespaceRegex) ||
                      value.endsWith("_"))
                  ? "Please enter a valid ticket number."
                  : null;
                },
              ),
              const SizedBox(height: 4,),
              const Text("Please enter your ticket number, as it appears on your ticket.",
                style: TextStyle(color: Colors.white70,fontSize: 12, fontWeight:FontWeight.bold), textAlign: TextAlign.justify,),
              const SizedBox(height: 12,),
              SizedBox(
                width:180,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white,
                    foregroundColor: Colors.black
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(Register(mumbleUserController.text));
                    }
                  },
                  child: const Text("Register"),
                ),
              )
            ],
          ),
        ),
    );
  }
}
