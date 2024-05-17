import 'package:fitinbox/service/email/get_emails.dart';
import 'package:fitinbox/service/user/get_email_name.dart';
import 'package:fitinbox/service/user/get_user.dart';
import 'package:fitinbox/views/web_view/email_web_view.dart';
import 'package:fitinbox/widgets/email_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailView extends StatefulWidget {
  const EmailView({super.key});

  @override
  State<EmailView> createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  Map<String, dynamic> emails = {};
  bool isLoading = false;

  MenuType currentMenuType = MenuType.normal;

  String selectedUuid = '';

  Map<String, dynamic> emailName = {};

  Future<void> getEmailData() async {
    setState(() {
      isLoading = true;
    });

    final getEmailsResult = await getEmails();

    if (getEmailsResult["result"]) {
      // final normalEmails = getEmailsResult["data"];
      setState(() {
        getEmailsResult["data"].forEach((key, value) {
          emails[key] = value.reversed.toList();
        });
      });
    }

    List<String> keys = emails.keys.toList();

    for (int i = 0; i < keys.length; i++) {
      emailName[keys[i]] = (await getEmailName(emailUuid: keys[i]))["data"];
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> sortEmails({required MenuType menuType}) async {
    if (menuType == MenuType.normal) {
      await getEmailData();
      return;
    }

    if (menuType == MenuType.score) {
      await getEmailData();
      emails.forEach((key, value) {
        if (value.length > 1) value.sort((a, b) => (b["score"] as num).compareTo(a["score"] as num));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    sortEmails(menuType: MenuType.normal).then((_) async {
      if (emails.isNotEmpty) {
        setState(() {
          selectedUuid = emails.keys.toList()[0];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              border: const Border(),
              largeTitle: const Text("Emails"),
              trailing: PopupMenuButton<MenuType>(
                color: Colors.white,
                onSelected: (MenuType result) {
                  sortEmails(menuType: result);
                  // currentMenuType = result;
                },
                itemBuilder: (BuildContext buildContext) {
                  return [
                    const PopupMenuItem(
                      value: MenuType.normal,
                      child: Text("기본순으로"),
                    ),
                    const PopupMenuItem(
                      value: MenuType.score,
                      child: Text("높은 점수순으로"),
                    ),
                  ];
                },
              ),
            ),
          ];
        },
        body: isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RefreshIndicator(
                  onRefresh: () async {
                    sortEmails(menuType: currentMenuType);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            String uuid = emails.keys.elementAt(index);

                            return CupertinoButton(
                              minSize: 0,
                              padding: EdgeInsets.zero,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: uuid == selectedUuid ? Colors.white : Colors.black),
                                  color: uuid == selectedUuid ? Colors.black : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  emailName[uuid],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: uuid == selectedUuid ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedUuid = uuid;
                                });
                              },
                            );
                          },
                          separatorBuilder: (_, __) {
                            return const SizedBox(width: 8);
                          },
                          itemCount: emails.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      emails.isEmpty
                          ? const SizedBox.shrink()
                          : Expanded(
                              child: ListView.separated(
                                key: UniqueKey(),
                                itemBuilder: (BuildContext context, int index) {
                                  return emailPreview(
                                    email: emails[selectedUuid][index],
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EmailWebView(
                                            title: "",
                                            html: emails[selectedUuid][index]["content"],
                                            email: emails[selectedUuid][index],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                separatorBuilder: (_, __) {
                                  return Divider(
                                    thickness: 0.5,
                                    height: 10,
                                    color: Colors.grey.shade300,
                                  );
                                },
                                itemCount: selectedUuid.isEmpty ? 0 : emails[selectedUuid]!.length,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

enum MenuType { score, normal }
