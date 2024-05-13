import 'package:fitinbox/service/email/get_emails.dart';
import 'package:fitinbox/service/utils.dart';
import 'package:fitinbox/views/web_view/email_web_view.dart';
import 'package:fitinbox/widgets/email_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailView extends StatefulWidget {
  const EmailView({super.key});

  @override
  State<EmailView> createState() => _FilterViewState();
}

class _FilterViewState extends State<EmailView> {
  List emails = [];

  void getEmailData() {
    getEmails().then((value) {
      if (value["result"]) {
        setState(() {
          emails = value["data"];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getEmailData();
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
              largeTitle: Text("Emails"),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return emailPreview(
                email: emails[index],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmailWebView(
                        title: "",
                        html: emails[index]["content"],
                        email: emails[index],
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
            itemCount: emails.length,
          ),
        ),
      ),
    );
  }
}
