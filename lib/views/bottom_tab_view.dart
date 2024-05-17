import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitinbox/service/notification/notification_handler.dart';
import 'package:fitinbox/views/email/email_view.dart';
import 'package:fitinbox/views/user/user_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomTabView extends StatefulWidget {
  const BottomTabView({super.key});

  @override
  State<BottomTabView> createState() => _BottomTabViewState();
}

class _BottomTabViewState extends State<BottomTabView> {
  final List<String> _tabBarTitleList = ['Email', 'User'];

  final List<String> _tabBarImageActivePathList = [
    'assets/svg/tab/home-on.svg',
    'assets/svg/tab/profile-on.svg',
  ];

  final List<String> _tabBarImageInActivePathList = [
    'assets/svg/tab/home-off.svg',
    'assets/svg/tab/profile-off.svg',
  ];

  final List<Widget> _widgetOptions = <Widget>[
    const EmailView(),
    const UserView(),
  ];

  final CupertinoTabController _cupertinoTabController = CupertinoTabController(initialIndex: 0);

  void handleMessage(RemoteMessage message) {
    // message.data;
  }

  @override
  void initState() {
    super.initState();

    // foreground 수신처리
    FirebaseMessaging.onMessage.listen(showAndroidFlutterNotification);

    // 알림 클릭 시
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _cupertinoTabController,
      tabBar: CupertinoTabBar(
        activeColor: const Color(0XFF222222),
        border: const Border(top: BorderSide(color: Colors.white, width: 0.0)),
        backgroundColor: Colors.white,
        items: List.generate(2, (int index) {
          return BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              _tabBarImageActivePathList[index],
              width: 24,
              height: 24,
            ),
            icon: SvgPicture.asset(
              _tabBarImageInActivePathList[index],
              width: 24,
              height: 24,
            ),
            label: _tabBarTitleList[index],
          );
        }),
      ),
      tabBuilder: (context, index) {
        return _widgetOptions[index];
      },
    );
  }
}
