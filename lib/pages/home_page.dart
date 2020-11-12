import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/pages/login_page.dart';
import 'package:go_class_parent/widgets/widgets.dart';

import 'appbar/downloads.dart';
import 'canteen/canteen_page.dart';
import 'payments/payments_page.dart';
import 'planning/schedule.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'home/';

  String _title = "Accueil";
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (oldState, newState) => newState is LogoutState,
          listener: (context, state) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
          },
          child: MyAppDrawer()),
      key: _scaffoldKey,
      appBar: MyAppBar(title: _title),
      // drawer: MyAppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  _buildTile(
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Travail de maison',
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22.0),
                                ),
                                Text(
                                  'Toute la liste',
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                )
                              ],
                            ),
                            Material(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(24.0),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Icon(Icons.assistant_photo,
                                      color: Colors.white, size: 30.0),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      _comingSoon(context);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      _buildTile(
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 30,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Material(
                                      color: Colors.teal,
                                      shape: CircleBorder(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Icon(Icons.fastfood,
                                            color: Colors.white, size: 30.0),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 16.0),
                                  ),
                                  Text(
                                    'Cantine',
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24.0),
                                  ),
                                  Text(
                                    'Détails',
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          BlocProvider.of<CanteenBloc>(context).add(
                              LoadCanteenEvent(
                                  currentUserID: (await BlocProvider.of<
                                              AuthenticationBloc>(context)
                                          .parent)
                                      .serverId));
                          Navigator.of(context)
                              .pushNamed(CanteenPage.routeName);
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _buildTile(
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 15,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Material(
                                      color: Colors.blueGrey,
                                      shape: CircleBorder(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Icon(Icons.collections_bookmark,
                                            color: Colors.white, size: 30.0),
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 16.0)),
                                  Text(
                                    'Emplois du temps',
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 19.0),
                                  ),
                                  Text(
                                    'Consulter',
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          BlocProvider.of<ScheduleBloc>(context).add(
                              LoadScheduleEvent(
                                  currentUserID: (await BlocProvider.of<
                                              AuthenticationBloc>(context)
                                          .parent)
                                      .serverId));
                          Navigator.of(context)
                              .pushNamed(SchedulePage.routeName);
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _buildTile(
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Liste des paiements',
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22.0),
                                ),
                                Text(
                                  'Consulter le détail de paiement',
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                            Material(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(24.0),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Icon(Icons.attach_money,
                                      color: Colors.white, size: 30.0),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      BlocProvider.of<PaymentsBloc>(context).add(
                          LoadPaymentsEvent(
                              currentUserID:
                                  (await BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .parent)
                                      .serverId));
                      Navigator.of(context).pushNamed(PaymentsPage.routeName);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _buildTile(
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Liste des absences',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0,
                                  ),
                                ),
                                Text(
                                  'Voir les détails',
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                )
                              ],
                            ),
                            Material(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(24.0),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.assignment,
                                      color: Colors.white, size: 30.0),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      _comingSoon(context);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      _buildTile(
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 15,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Material(
                                      color: Colors.lightBlue,
                                      shape: CircleBorder(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Icon(Icons.cloud_download,
                                            color: Colors.white, size: 30.0),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 16.0),
                                  ),
                                  Text(
                                    'Documents',
                                    style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.0),
                                  ),
                                  Text('Télécharger',
                                      style: TextStyle(color: Colors.black45)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          BlocProvider.of<DownloadsBloc>(context)
                              .add(OpenDownloadsEvent());
                          Navigator.of(context)
                              .pushNamed(DownloadsPage.routeName);
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _buildTile(
                        Container(
                          width: (MediaQuery.of(context).size.width / 2) - 30,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Material(
                                      color: Colors.orange,
                                      shape: CircleBorder(),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Icon(Icons.mode_edit,
                                            color: Colors.white, size: 30.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 16.0),
                                    ),
                                    Text(
                                      'Examens',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24.0),
                                    ),
                                    Text(
                                      'Détails',
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        onTap: () {
                          _comingSoon(context);
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell(
          // Do onTap() if it isn't null, otherwise do print()
          onTap: onTap != null
              ? () => onTap()
              : () {
                  print('Not set yet');
                },
          child: child),
    );
  }

  _comingSoon(context) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text('Coming Soon...')));
  }
}
