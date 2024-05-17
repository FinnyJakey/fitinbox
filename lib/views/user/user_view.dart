import 'package:fitinbox/service/user/get_user.dart';
import 'package:fitinbox/views/user/user_add_view.dart';
import 'package:fitinbox/views/user/user_modify_view.dart';
import 'package:fitinbox/widgets/acocunt/account_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  List<dynamic> accounts = [];

  void getUserData() {
    getUser().then((value) {
      if (value["result"]) {
        setState(() {
          accounts = value["data"];
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
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              border: const Border(),
              largeTitle: const Text("User Setting"),
              trailing: CupertinoButton(
                minSize: 0,
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset("assets/svg/user/user_add.svg"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const UserAddView())).then((value) {
                    if (value != null) {
                      getUserData();
                    }
                  });
                },
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return accountContainer(
                email: accounts[index]["email"],
                filters: accounts[index]["filters"],
                score: accounts[index]["forwardScore"],
                recipient: accounts[index]["recipient"],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserModifyView(
                        email: accounts[index]["email"].split("@")[0],
                        recipient: accounts[index]["recipient"],
                        score: accounts[index]["forwardScore"],
                        uuid: accounts[index]["uuid"],
                        filter: accounts[index]["filters"],
                      ),
                    ),
                  ).then((value) {
                    if (value != null) {
                      getUserData();
                    }
                  });
                },
              );
            },
            separatorBuilder: (_, __) {
              return const SizedBox(height: 12);
            },
            itemCount: accounts.length,
          ),
        ),
      ),
    );
  }
}
