import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/cubits/cubits.dart';
import 'package:go_class_parent/pages/home_work/units_list.dart';
import 'package:go_class_parent/pages/pages.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/widgets/widgets.dart';

import 'backend/blocs/blocs.dart';
import 'backend/fcm/fcm.dart' as fcm;
import 'backend/repositories/repositories.dart';

void main() {
  Bloc.observer = ApplicationObserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        create: (_) =>
            AuthenticationBloc(repository: AuthenticationRepository())
              ..add(AppLaunched()),
      ),
      BlocProvider<NotificationsBloc>(
        create: (_) => NotificationsBloc(),
      ),
      BlocProvider<MessagesBloc>(
        create: (_) => MessagesBloc(),
      ),
      BlocProvider<DownloadsBloc>(
        create: (_) => DownloadsBloc(repository: DownloadsRepository()),
      ),
      BlocProvider<SettingsBloc>(
        create: (_) => SettingsBloc(),
      ),
      BlocProvider<ScheduleBloc>(
        create: (_) => ScheduleBloc(),
      ),
      BlocProvider<PaymentsBloc>(
        create: (_) => PaymentsBloc(),
      ),
      BlocProvider<CanteenBloc>(
        create: (_) => CanteenBloc(),
      ),
      BlocProvider<ChildrenBloc>(
        create: (_) => ChildrenBloc(),
      ),
      BlocProvider<AttendanceBloc>(
        create: (_) => AttendanceBloc(),
      ),
      BlocProvider<SynchronizationBloc>(
        create: (_) => SynchronizationBloc(),
      ),
      BlocProvider<HomeWorkBloc>(
        create: (_) => HomeWorkBloc(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    fcm.context = context;
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        // _showItemDialog(message);
        return fcm.displayNotification(message);
      },
      onBackgroundMessage:
          Platform.isIOS ? null : fcm.myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
        return;
      },
    );

    // todo add multi bloc consumer or listener to check notification token and send it

    return MaterialApp(
      title: 'GoClassParentParent',
      theme: ThemeData(
        primarySwatch: appSwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case UnAuthenticated:
              return IntroPages();
            case Authenticated:
              return HomePage();
            default:
              return IntroPages();
          }
        },
      ),
      routes: {
        IntroPages.routeName: (context) => IntroPages(),
        LoginPage.routeName: (context) => LoginPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        InitialPage.routeName: (context) => InitialPage(),
        OtpPage.routeName: (context) => OtpPage(),
        HomePage.routeName: (context) => HomePage(),
        ForgotPassword.routeName: (context) => ForgotPassword(),
        NewPassword.routeName: (context) => NewPassword(),
        Messages.routeName: (context) => Messages(),
        Notifications.routeName: (context) => Notifications(),
        ConversationDialog.routeName: (context) => ConversationDialog(),
        NewMessagePage.routeName: (context) => NewMessagePage(),
        DownloadsPage.routeName: (context) => DownloadsPage(),
        SchedulePage.routeName: (context) => SchedulePage(),
        PaymentsPage.routeName: (context) => PaymentsPage(),
        PaymentsList.routeName: (context) => PaymentsList(),
        CanteenPage.routeName: (context) => CanteenPage(),
        CanteenList.routeName: (context) => CanteenList(),
        StudentsListPage.routeName: (context) => StudentsListPage(),
        AttendanceChildrenPage.routeName: (context) => AttendanceChildrenPage(),
        AttendanceList.routeName: (context) => AttendanceList(),
        MatiereListPage.routeName: (context) => MatiereListPage(),
        ClassesListPage.routeName: (context) => ClassesListPage(),
        HomeWorkListPage.routeName: (context) => HomeWorkListPage(),
        UnitListPage.routeName: (context) => UnitListPage(),
        MarksPage.routeName: (context) => MarksPage(),
      },
    );
  }
}

class IntroPages extends StatelessWidget {
  static const String routeName = '/intro';

  const IntroPages({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroPageView(),
    );
  }
}
