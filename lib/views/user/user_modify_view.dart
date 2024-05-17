import 'package:fitinbox/service/user/delete_user.dart';
import 'package:fitinbox/service/user/modify_user.dart';
import 'package:fitinbox/views/user/filter_add_view.dart';
import 'package:fitinbox/widgets/default_scaffold.dart';
import 'package:fitinbox/widgets/one_line_text_field.dart';
import 'package:fitinbox/widgets/secondary_button.dart';
import 'package:fitinbox/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserModifyView extends StatefulWidget {
  const UserModifyView({super.key, required this.email, required this.recipient, required this.score, required this.uuid, required this.filter});

  final String email;
  final String recipient;
  final num score;
  final String uuid;
  final Map<String, dynamic> filter;

  @override
  State<UserModifyView> createState() => _UserModifyViewState();
}

class _UserModifyViewState extends State<UserModifyView> {
  bool isSending = false;

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController recipientEditingController = TextEditingController();
  TextEditingController forwardScoreEditingController = TextEditingController();

  Map<String, dynamic> filters = {};

  @override
  void initState() {
    super.initState();
    emailEditingController.text = widget.email;
    recipientEditingController.text = widget.recipient;
    forwardScoreEditingController.text = widget.score.toString();
    filters = widget.filter;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backButton: true,
      title: const Text(
        "Modify User",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        CupertinoButton(
          minSize: 0,
          padding: const EdgeInsets.all(4),
          child: const Icon(
            Icons.remove_circle_outline,
            color: Colors.redAccent,
          ),
          onPressed: () async {
            await deleteUser(uuid: widget.uuid);
            if (context.mounted) Navigator.pop(context, true);
          },
        ),
      ],
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
                        "Change Filter",
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
                title: isSending ? "Loading" : "Apply",
                disabled: isSending,
                onPressed: () async {
                  if (emailEditingController.text.isEmpty || recipientEditingController.text.isEmpty || forwardScoreEditingController.text.isEmpty || filters.isEmpty) {
                    showBooleanToast(context, granted: false, message: "항목을 전부 채워주세요.");
                    return;
                  }

                  setState(() {
                    isSending = true;
                  });

                  final modifyUserResult = await modifyUser(uuid: widget.uuid, email: emailEditingController.text, filters: filters, score: num.parse(forwardScoreEditingController.text), recipient: recipientEditingController.text);

                  if (modifyUserResult["result"]) {
                    if (context.mounted) {
                      showBooleanToast(context, granted: true, message: "계정이 변경되었습니다!");
                      Navigator.pop(context, true);
                    }
                  } else {
                    if (context.mounted) showBooleanToast(context, granted: false, message: modifyUserResult["message"]);
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
