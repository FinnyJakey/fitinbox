import 'package:fitinbox/service/user/add_user.dart';
import 'package:fitinbox/views/user/filter_add_view.dart';
import 'package:fitinbox/widgets/default_scaffold.dart';
import 'package:fitinbox/widgets/one_line_text_field.dart';
import 'package:fitinbox/widgets/secondary_button.dart';
import 'package:fitinbox/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserAddView extends StatefulWidget {
  const UserAddView({super.key});

  @override
  State<UserAddView> createState() => _UserAddViewState();
}

class _UserAddViewState extends State<UserAddView> {
  bool isSending = false;

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController recipientEditingController = TextEditingController();
  TextEditingController forwardScoreEditingController = TextEditingController();

  Map<String, dynamic> filters = {};

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backButton: true,
      title: const Text(
        "Add User",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 8),
              const Text(
                "Filter",
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SvgPicture.asset("assets/svg/toast/${filters.isEmpty ? "slash-circle-01.svg" : "check.svg"}"),
                  const SizedBox(width: 8),
                  Text(
                    filters.isEmpty ? "Not Applied" : "Applied",
                    style: TextStyle(
                      color: filters.isEmpty ? Colors.redAccent : Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    filters.isEmpty ? "" : filters["name"],
                    style: TextStyle(
                      color: filters.isEmpty ? Colors.redAccent : Colors.green,
                    ),
                  ),
                  const Spacer(),
                  CupertinoButton(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Add Filter",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FilterAddView())).then((value) {
                        if (value != null) {
                          setState(() {
                            filters = value;
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                color: Colors.black87,
                title: isSending ? "Loading" : "Add",
                disabled: isSending,
                onPressed: () async {
                  if (emailEditingController.text.isEmpty || recipientEditingController.text.isEmpty || forwardScoreEditingController.text.isEmpty || filters.isEmpty) {
                    showBooleanToast(context, granted: false, message: "항목을 전부 채워주세요.");
                    return;
                  }

                  setState(() {
                    isSending = true;
                  });

                  final addUserResult = await addUser(email: emailEditingController.text, filters: filters, score: num.parse(forwardScoreEditingController.text), recipient: recipientEditingController.text);

                  if (addUserResult["result"]) {
                    if (context.mounted) {
                      showBooleanToast(context, granted: true, message: "계정이 추가되었습니다!");
                      Navigator.pop(context, true);
                    }
                  } else {
                    if (context.mounted) showBooleanToast(context, granted: false, message: addUserResult["message"]);
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
