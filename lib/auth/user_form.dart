import 'package:flutter/material.dart';
import 'package:sgela_shared_widgets/util/gaps.dart';
import 'package:sgela_shared_widgets/util/styles.dart';

class UserForm extends StatelessWidget {
  const UserForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit, required this.globalKey,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final Function onSubmit;
  final GlobalKey<FormState> globalKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: globalKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            controller: firstNameController,
            validator: (value){
              if (value == null || value.isEmpty) {
                return 'Enter first name';
              }
              return null;
          },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: ' First Name',
              helperText: '',
              helperStyle: TextStyle(height: 0.7),
              errorStyle: TextStyle(height: 0.7),
            ),
          ),
          gapH4,
          TextFormField(
            controller: lastNameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              helperText: '',
              helperStyle: TextStyle(height: 0.7),
              errorStyle: TextStyle(height: 0.7),
            ),
            validator: (value){
              if (value == null || value.isEmpty) {
                return 'Enter last name';
              }
              return null;
            },
          ),
          gapH4,
          TextFormField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              helperText: '',
              helperStyle: TextStyle(height: 0.7),
              errorStyle: TextStyle(height: 0.7),
            ),
            validator: (value){
              if (value == null || value.isEmpty) {
                return 'Enter email address';
              }
              return null;
            },
          ),
          gapH4,
          TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(
              labelText: 'Password',
              helperText: 'Make a Good Password, eh?',
              helperStyle: TextStyle(height: 0.7),
              errorStyle: TextStyle(height: 0.7),
            ),
            validator: (value){
              if (value == null || value.isEmpty) {
                return 'Enter password';
              }
              return null;
            },
          ),
          gapH32,
          gapH32,
          gapH32,
          SizedBox(
            width: 300,
            child: ElevatedButton(
              style: const ButtonStyle(
                elevation: WidgetStatePropertyAll(8.0),
              ),
              onPressed: () {
                onSubmit();
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Submit',
                  style: myTextStyleMediumLarge(context, 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
