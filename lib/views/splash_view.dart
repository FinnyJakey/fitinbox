import 'package:fitinbox/service/auth/sign_in.dart';
import 'package:fitinbox/service/notification/notification_setup.dart';
import 'package:fitinbox/service/singleton/auth_service.dart';
import 'package:fitinbox/views/auth/auth_view.dart';
import 'package:fitinbox/views/bottom_tab_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late Future<void> splashFuture;
  late SplashStatus splashStatus;

  Future<void> _getInitLoad() async {
    if (await _getLoginNeed()) {
      splashStatus = SplashStatus.login;
      return;
    }

    splashStatus = SplashStatus.none;
  }

  Future<bool> _getLoginNeed() async {
    return true;

    final String id = AuthService.id;
    final String pw = AuthService.pw;

    if (id.isEmpty || pw.isEmpty) {
      return true;
    }

    final signInResult = await signIn(email: id, password: pw);

    if (signInResult["result"]) {
      AuthService.changeUuid(toChangeUuid: signInResult["uuid"]);

      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    notificationRequestPermission(context);
    splashFuture = Future.delayed(const Duration(milliseconds: 500), () => _getInitLoad());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: splashFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const SplashLoadingScreen();
          default:
            switch (splashStatus) {
              case SplashStatus.none:
                return const BottomTabView();
              case SplashStatus.login:
                return const AuthView();
            }
        }
      },
    );
  }
}

class SplashLoadingScreen extends StatelessWidget {
  const SplashLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/svg/archive.svg",
                width: 60,
                height: 60,
              ),
              const SizedBox(width: 8),
              Text(
                "Fit-Inbox",
                style: GoogleFonts.lora(
                  textStyle: const TextStyle(
                    letterSpacing: 0,
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum SplashStatus { login, none }
