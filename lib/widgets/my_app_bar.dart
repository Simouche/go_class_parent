import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/pages/pages.dart';
import 'package:go_class_parent/values/Colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key key,
    @required this.title,
    this.showActions = true,
    this.tabBar,
  }) : super(key: key);

  final String title;
  final bool showActions;
  final TabBar tabBar;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SynchronizationBloc, SynchronizationState>(
      listener: (context, state) {
        if (state is SynchronizationSuccessState)
          BlocProvider.of<MessagesBloc>(context)
              .add(GetNewMessagesCountEvent());
      },
      child: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: MAIN_COLOR_LIGHT,
        elevation: 0.0,
        title: Text(title),
        actions: showActions
            ? <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.group,
                    color: WHITE,
                  ),
                  tooltip: "Scannez un code",
                  onPressed: () async {
                    print("pressed");
                    BlocProvider.of<ChildrenBloc>(context).add(
                      GetStudentsEventEvent(
                        userID:
                            (await BlocProvider.of<AuthenticationBloc>(context)
                                    .parent)
                                .serverId,
                      ),
                    );
                    Navigator.of(context).pushNamed(StudentsListPage.routeName);
                  },
                ),
                Stack(children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.mail,
                      color: WHITE,
                    ),
                    tooltip: "Messages",
                    onPressed: () async {
                      BlocProvider.of<MessagesBloc>(context).add(
                          LoadMessagesEvent(
                              (await BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .parent)
                                      .serverId ??
                                  ""));
                      Navigator.of(context).pushNamed(Messages.routeName);
                    },
                  ),
                  BlocBuilder<MessagesBloc, MessagesState>(
                    buildWhen: (oldState, newState) {
                      return newState is MessagesCountState;
                    },
                    builder: (context, state) {
                      if (state is MessagesCountState)
                        return state.newMessageCount > 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 20.0, left: 2.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Text(
                                    "${state.newMessageCount}",
                                    style:
                                        TextStyle(color: WHITE, fontSize: 10.0),
                                  ),
                                  radius: 8.0,
                                ),
                              )
                            : Container();
                      return Container();
                    },
                  )
                ]),
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  tooltip: "Notifications",
                  onPressed: () async {
                    BlocProvider.of<NotificationsBloc>(context).add(
                      LoadNotificationEvent(
                          (await BlocProvider.of<AuthenticationBloc>(context)
                                      .parent)
                                  .serverId ??
                              ""),
                    );
                    Navigator.of(context).pushNamed(Notifications.routeName);
                  },
                ),
              ]
            : null,
        bottom: tabBar,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
