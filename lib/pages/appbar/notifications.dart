import 'dart:developer';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/models.dart' as models;
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class Notifications extends StatelessWidget {
  static const String routeName = 'home/notifications';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<NotificationsBloc>(context).add(
          LoadNotificationEvent(
              (await BlocProvider.of<AuthenticationBloc>(context).parent)
                      .serverId ??
                  ""),
        );
        return true;
      },
      child: Scaffold(
        appBar: MyAppBar(title: "Notifications", showActions: false),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          buildWhen: (oldState, newState) {
            return newState is NotificationsLoadingFailed ||
                newState is NotificationsLoaded;
          },
          builder: (context, state) {
            if (state is NotificationsLoadingFailed) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Pas de notification')));
              return Center(
                child: Text('Pas de notification.'),
              );
            } else if (state is NotificationsLoaded) {
              log("notification layout will Load");
              final NotificationsLoaded newState = state;
              return NotificationTimeLine(
                  notifications: newState.notifications);
            } else {
              return Center(
                child: Text('No notification.'),
              );
            }
          },
        ),
      ),
    );
  }
}

class NotificationTimeLine extends StatelessWidget {
  const NotificationTimeLine({
    Key key,
    this.notifications,
  }) : super(key: key);

  final List<models.Notification> notifications;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DownloadsBloc, DownloadsState>(
        listener: (context, state) {
          if (state is DownloadsInProgressState) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Telechargement en cours..."),
            ));
          } else if (state is DownloadsSuccessfulState)
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Fichiers telechargés avec succés, veuillez voir la"
                  " pages des telechargement"),
            ));
        },
        child: Container(
            child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SideLine(isNew: notifications[index].seen ?? true),
                  NotificationBody(
                    notification: notifications[index],
                  ),
                ],
              ),
            );
          },
        )));
  }
}

class NotificationBody extends StatelessWidget {
  const NotificationBody({
    Key key,
    this.notification,
  }) : super(key: key);

  final models.Notification notification;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          if (notification.fileUrl.isEmpty) {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("Aucun fichier a telecharger")));
          } else if (notification.downloaded) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Fichier déja telechargé,"
                    " veuillez consultez la page des telechargements."),
              ),
            );
          } else {
            if (await Permission.storage.request().isGranted) {
              BlocProvider.of<DownloadsBloc>(context)
                  .add(TriggerDownloadsEvent(files: notification.fileUrl));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Permission refusée"),
              ));
            }
          }
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: WHITE,
            border: Border(
              bottom: BorderSide(width: 6, color: MAIN_COLOR_LIGHT),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 10.0,
                color: Colors.black26,
              ),
            ],
          ),
          // height: !isTapped ? 100.0 : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification.from ?? "",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      notification.date,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Text(
                  notification.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Html(
                  data: notification.message,
                ),
                SizedBox(height: 2.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.cloud_download,
                      color: notification.fileUrl?.isNotEmpty ?? false
                          ? MAIN_COLOR_LIGHT
                          : Colors.grey,
                    ),
//                    Icon(false
//                        ? Icons.keyboard_arrow_up
//                        : Icons.keyboard_arrow_down)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SideLine extends StatelessWidget {
  const SideLine({
    Key key,
    this.isNew,
  }) : super(key: key);

  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 2.0,
          height: 65.0,
          color: Colors.black,
        ),
        Container(
          margin: EdgeInsets.only(left: 5.0, right: 5.0),
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: WHITE,
            borderRadius: BorderRadius.circular(50),
          ),
          child: !isNew
              ? Icon(
                  Icons.notifications,
                  color: MAIN_COLOR_LIGHT,
                  size: 30.0,
                )
              : ShakeAnimatedWidget(
                  enabled: true,
                  duration: Duration(milliseconds: 1000),
                  shakeAngle: Rotation.deg(z: 40),
                  curve: Curves.linear,
                  child: Icon(
                    Icons.notifications_active,
                    color: MAIN_COLOR_LIGHT,
                    size: 30.0,
                  ),
                ),
        ),
        Container(
          width: 2.0,
          height: 65.0,
          color: Colors.black,
        ),
      ],
    );
  }
}
