import 'package:fitinbox/service/auth/sign_in.dart';
import 'package:fitinbox/service/singleton/auth_service.dart';
import 'package:fitinbox/views/auth/sign_up_view.dart';
import 'package:fitinbox/views/bottom_tab_view.dart';
import 'package:fitinbox/widgets/default_scaffold.dart';
import 'package:fitinbox/widgets/one_line_text_field.dart';
import 'package:fitinbox/widgets/secondary_button.dart';
import 'package:fitinbox/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  TextEditingController idEditingController = TextEditingController();
  TextEditingController pwEditingController = TextEditingController();

  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login to Fit-Inbox",
                style: GoogleFonts.lora(
                  textStyle: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Create your own filters for your emails",
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
                    const SizedBox(height: 12),
                    SecondaryButton(
                      color: Colors.black87,
                      title: isSending ? "Loading" : "Continue",
                      disabled: isSending,
                      onPressed: () async {
                        setState(() {
                          isSending = true;
                        });

                        final signInResult = await signIn(email: idEditingController.text, password: pwEditingController.text);

                        setState(() {
                          isSending = false;
                        });

                        if (signInResult["result"]) {
                          AuthService.changeUuid(toChangeUuid: signInResult["uuid"]);

                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BottomTabView()), (route) => false);
                        } else {
                          if (context.mounted) {
                            showBooleanToast(context, granted: false, message: "Authentication failed");
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      letterSpacing: 0,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpView()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        letterSpacing: 0,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
