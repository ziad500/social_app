import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/modules/loginScreen/login_screen.dart';
import 'package:social_app/modules/register_screen/states.dart';
import '../../shared/components/components.dart';
import 'cubit.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateSuccessState) {
            navigateAndFinish(context, const SocialLayout());
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Register",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Register Now To Browse Our Hot Offers",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
                        defaultFormField(context,
                            controller: nameController,
                            type: TextInputType.name,
                            validate: (String? value) {
                          if (value!.isEmpty) {
                            return "Please Enter Your name";
                          }
                          return null;
                        }, label: "Name", prefix: Icons.person),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(context,
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String? value) {
                          if (value!.isEmpty) {
                            return "Please Enter Your Email";
                          }
                          return null;
                        },
                            label: "Email Address",
                            prefix: Icons.email_outlined),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(context,
                            controller: phoneController,
                            type: TextInputType.phone,
                            validate: (String? value) {
                          if (value!.isEmpty) {
                            return "Please Enter Your phone";
                          }
                          return null;
                        }, label: "Name", prefix: Icons.phone),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          context,
                          isPassword:
                              SocialRegisterCubit.get(context).isVisible,
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              SocialRegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text);
                            }
                            return null;
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return "Please Enter Your Password";
                            }
                            return null;
                          },
                          label: "Password",
                          prefix: Icons.lock_outline,
                          suffix: SocialRegisterCubit.get(context).suffix,
                          suffixPressed: () {
                            SocialRegisterCubit.get(context)
                                .changePasswordVisiblility();
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        state is SocialRegisterLoadingState
                            ? const Center(child: CircularProgressIndicator())
                            : Center(
                                child: defaultButton(
                                    function: () {
                                      if (formKey.currentState!.validate()) {
                                        SocialRegisterCubit.get(context)
                                            .userRegister(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                                name: nameController.text,
                                                phone: phoneController.text);
                                      }
                                    },
                                    text: "Register",
                                    isUpperCase: true),
                              ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Have An Account?"),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, SocialLoginScreen());
                                },
                                child: Text(
                                  'Login'.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
