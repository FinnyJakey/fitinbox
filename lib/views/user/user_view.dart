import 'package:fitinbox/service/user/get_user.dart';
import 'package:fitinbox/service/user/modify_user.dart';
import 'package:fitinbox/widgets/one_line_text_field.dart';
import 'package:fitinbox/widgets/secondary_button.dart';
import 'package:fitinbox/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController recipientEditingController = TextEditingController();
  TextEditingController forwardScoreEditingController = TextEditingController();

  bool isSending = false;

  void getUserData() {
    getUser().then((value) {
      if (value["result"]) {
        setState(() {
          emailEditingController.text = value["data"]["emailName"];
          recipientEditingController.text = value["data"]["recipient"];
          forwardScoreEditingController.text = value["data"]["forwardScore"].toString();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            const CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              border: Border(),
              largeTitle: Text("User Setting"),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const Text(
                "Your Fit-Inbox email address",
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: OneLineTextField(textEditingController: emailEditingController, onChanged: (_) {}, hintText: "someone")),
                  const SizedBox(width: 4),
                  const Expanded(
                    flex: 2,
                    child: Text(
                      "@fitinbox.online",
                      style: TextStyle(
                        letterSpacing: 0,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/user/switch.svg",
                    colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Fit-Inbox will forward important emails to recipient",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Recipient email address",
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              OneLineTextField(textEditingController: recipientEditingController, onChanged: (_) {}, hintText: "someone@example.com"),
              const SizedBox(height: 16),
              const Text(
                "Forward Score",
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              OneLineTextField(
                textEditingController: forwardScoreEditingController,
                onChanged: (_) {},
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                hintText: "8.0",
              ),
              const SizedBox(height: 8),
              const Text(
                "If the importance of the email is equal to or higher than the forward score you set, will send you forward email and push notification.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                color: Colors.black87,
                title: isSending ? "Loading" : "Update",
                disabled: isSending,
                onPressed: () async {
                  setState(() {
                    isSending = true;
                  });

                  try {
                    final forwardScore = double.parse(forwardScoreEditingController.text);
                    final modifyUserResult = await modifyUser(emailName: emailEditingController.text, recipient: recipientEditingController.text, forwardScore: forwardScore);

                    if (modifyUserResult["result"]) {
                      if (context.mounted) showBooleanToast(context, granted: true, message: "변경되었습니다!");

                      getUserData();
                    } else {
                      if (context.mounted) showBooleanToast(context, granted: false, message: modifyUserResult["message"]);
                    }
                  } catch (e) {
                    if (context.mounted) showBooleanToast(context, granted: false, message: e.toString());
                  }

                  setState(() {
                    isSending = false;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
