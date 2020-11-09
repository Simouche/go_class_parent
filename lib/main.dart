import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/pages/pages.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/widgets/widgets.dart';

import 'backend/blocs/blocs.dart';
import 'backend/repositories/repositories.dart';

void main() {
  Bloc.observer = ApplicationObserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc(repository: AuthenticationRepository())
                ..add(AppLaunched())),
      BlocProvider<NotificationsBloc>(
        create: (context) => NotificationsBloc(),
      ),
      BlocProvider<MessagesBloc>(
        create: (context) => MessagesBloc(),
      ),
      BlocProvider<DownloadsBloc>(
        create: (context) => DownloadsBloc(repository: DownloadsRepository()),
      ),
      BlocProvider<SettingsBloc>(
        create: (context) => SettingsBloc(),
      ),
      BlocProvider<ScheduleBloc>(
        create: (context) => ScheduleBloc(),
      ),
      BlocProvider<PaymentsBloc>(
        create: (context) => PaymentsBloc(),
      ),
      BlocProvider<CanteenBloc>(
        create: (context) => CanteenBloc(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
//        Biology.routeName: (context) => Biology(),
//        Chemistry.routeName: (context) => Chemistry(),
//        Mathematics.routeName: (context) => Mathematics(),
//        Physics.routeName: (context) => Physics(),
//        Reasoning.routeName: (context) => Reasoning(),
//        SocialScience.routeName: (context) => SocialScience(),
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
