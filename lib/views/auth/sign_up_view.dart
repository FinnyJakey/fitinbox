import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitinbox/service/auth/sign_up.dart';
import 'package:fitinbox/service/utils.dart';
import 'package:fitinbox/views/splash_view.dart';
import 'package:fitinbox/widgets/default_scaffold.dart';
import 'package:fitinbox/widgets/one_line_text_field.dart';
import 'package:fitinbox/widgets/secondary_button.dart';
import 'package:fitinbox/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController idEditingController = TextEditingController();
  TextEditingController pwEditingController = TextEditingController();
  TextEditingController pwMatchEditingController = TextEditingController();

  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backButton: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: GoogleFonts.lora(
                  textStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Join us and use it right now!",
                style: TextStyle(
                  letterSpacing: 0,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    OneLineTextField(
                      textEditingController: idEditingController,
                      hintText: "someone@example.com",
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 8),
                    OneLineTextField(
                      textEditingController: pwEditingController,
                      hintText: "password",
                      onChanged: (_) {},
                      obscureText: true,
                    ),
                    const SizedBox(height: 8),
                    OneLineTextField(
                      textEditingController: pwMatchEditingController,
                      hintText: "Re-password",
                      onChanged: (_) {},
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    SecondaryButton(
                      color: Colors.black87,
                      title: isSending ? "Loading" : "Sign Up",
                      disabled: isSending,
                      onPressed: () async {
                        if (!isValidEmailFormat(idEditingController.text)) {
                          showBooleanToast(context, granted: false, message: 'Check your Email format');
                          return;
                        }

                        if (pwEditingController.text != pwMatchEditingController.text) {
                          showBooleanToast(context, granted: false, message: 'The passwords are different.');
                          return;
                        }

                        setState(() {
                          isSending = true;
                        });

                        final String? fcmToken = await FirebaseMessaging.instance.getToken();

                        final signUpResult = await signUp(email: idEditingController.text, password: pwEditingController.text, deviceToken: fcmToken!);

                        setState(() {
                          isSending = false;
                        });

                        if (!signUpResult["result"]) {
                          if (context.mounted) {
                            showBooleanToast(context, granted: false, message: signUpResult["message"]);
                          }

                          return;
                        }

                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SplashView()), (route) => false);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
