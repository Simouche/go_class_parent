import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/widgets/widgets.dart';

import 'conversation_dialog.dart';

class Messages extends StatelessWidget {
  static const String routeName = 'home/messages';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<MessagesBloc>(context).add(GetNewMessagesCountEvent());
        return true;
      },
      child: Scaffold(
        appBar: MyAppBar(title: "Messages", showActions: false),
        // drawer: MyAppDrawer(),
        body: BlocConsumer<MessagesBloc, MessagesState>(
          buildWhen: (oldState, newState) {
            return newState is MessagesLoaded ||
                newState is MessagesLoading ||
                newState is MessagesLoadingFailed;
          },
          listener: (context, state) {
            if (state is OpenConversationState)
              Navigator.of(context).pushNamed(ConversationDialog.routeName);
          },
          builder: (context, state) {
            if (state is MessagesLoaded) {
              MessagesLoaded newState = state;
              return MessagesBody(
                  data: newState.data,
                  ceo: state.ceo,
                  conversations: state.conversations);
            } else if (state is MessagesLoading) {
              return Center(child: Text("Chargement des messages."));
            } else if (state is MessagesLoadingFailed) {
              return Center(
                  child: Text(
                      "Échec du chargement de vos messages, réessayez plus tard"));
            } else {
              return Center(child: Text("Veuillez recharger"));
            }
          },
        ),
      ),
    );
  }
}

class MessagesBody extends StatefulWidget {
  MessagesBody({
    Key key,
    this.data,
    this.conversations,
    this.ceo,
  }) : super(key: key);

  final List<StudentWithDirectorAndTeachers> data;
  final List<dynamic> conversations;
  final CEO ceo;

  @override
  _MessagesBodyState createState() => _MessagesBodyState();
}

class _MessagesBodyState extends State<MessagesBody> {
  get dropDownMenuItems => List.generate(
      widget.data.length,
      (index) => DropdownMenuItem(
          value: index, child: Text(widget.data[index].student.toString())));

  int currentChild = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Card(
          elevation: 5.0,
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 2.0, bottom: 8.0),
                child: DropdownButton(
                    items: dropDownMenuItems,
                    value: currentChild,
                    onChanged: (int newValue) {
                      setState(() {
                        currentChild = newValue;
                      });
                    }),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => BlocProvider.of<MessagesBloc>(context).add(
                      OpenConversationEvent(
                        contactID: widget.ceo.serverID,
                        type: 1,
                      ),
                    ),
                    child: _AdminAvatar(
                      adminName: "CEO",
                      avatarPath: "assets/ceo_avatar.png",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<MessagesBloc>(context).add(
                        OpenConversationEvent(
                          contactID:
                              widget.data[currentChild].director.serverID,
                          type: 2,
                        ),
                      );
                    },
                    child: _AdminAvatar(
                      adminName: "Directeur",
                      avatarPath: "assets/admin_avatar.png",
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(left: 10.0),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          widget.data[currentChild].teachers.length,
                          (index) => Container(
                            margin: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<MessagesBloc>(context)
                                          .add(
                                        OpenConversationEvent(
                                          contactID: widget.data[currentChild]
                                              .teachers[index].serverID,
                                          type: 3,
                                        ),
                                      );
                                    },
                                    child: _ContactsAvatar()),
                                SizedBox(height: 10.0),
                                Text(widget.data[currentChild].teachers[index]
                                    .toString())
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: widget.conversations.length,
            separatorBuilder: (context, index) => const Divider(thickness: 1),
            itemBuilder: (context, index) {
              return Center(
                child: _MessageTile(
                  conversation: widget.conversations[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ContactsAvatar extends StatelessWidget {
  const _ContactsAvatar({
    Key key,
    this.marginTop = 45.0,
    this.marginLeft = 55.0,
  }) : super(key: key);

  final double marginTop;
  final double marginLeft;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        UserAvatar(),
        OnlineIndicator(
          marginTop: marginTop,
          marinLeft: marginLeft,
        ),
      ],
    );
  }
}

class _AdminAvatar extends StatelessWidget {
  const _AdminAvatar({
    Key key,
    this.adminName,
    this.avatarPath,
  }) : super(key: key);

  final String adminName;
  final String avatarPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Stack(
          children: [
            UserAvatar(avatarPath: avatarPath),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 60, left: 5.0),
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: MAIN_COLOR_DARK,
                ),
                child: Text(
                  adminName,
                  style: TextStyle(color: WHITE),
                ),
              ),
            ),
            OnlineIndicator()
          ],
        ),
      ),
    );
  }
}

class OnlineIndicator extends StatelessWidget {
  const OnlineIndicator({
    Key key,
    this.marginTop = 45.0,
    this.marinLeft = 55.0,
  }) : super(key: key);

  final double marginTop;
  final double marinLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        backgroundColor: WHITE,
        radius: 9.0,
        child: CircleAvatar(
          backgroundColor: Colors.green,
          radius: 7.0,
        ),
      ),
      margin: EdgeInsets.only(top: marginTop, left: 55.0),
    );
  }
}

class _MessageTile extends StatelessWidget {
  _MessageTile({
    Key key,
    this.conversation,
  }) : super(key: key);

  final dynamic conversation;

  @override
  Widget build(BuildContext context) {
    final String name = conversation.getName();

    final Message message = conversation.messages.last;

    return ListTile(
      leading: _ContactsAvatar(),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        textAlign: TextAlign.start,
      ),
      subtitle: Html(data: message.message),
      trailing: Column(
        children: [
          Text(message.date),
          SizedBox(height: 20.0),
          !message.seen
              ? CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text(
                    "",
                    style: TextStyle(color: WHITE, fontSize: 10.0),
                  ),
                  radius: 8.0,
                )
              : Text(""),
        ],
      ),
      onTap: () => BlocProvider.of<MessagesBloc>(context).add(
        OpenConversationEvent(
          contactID: conversation.toString(),
          type: conversation.getType(),
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
    this.avatarPath = "assets/avatar.png",
  }) : super(key: key);

  final String avatarPath;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 35.0,
      backgroundColor: MAIN_COLOR_LIGHT,
      child: CircleAvatar(
        radius: 33.0,
        backgroundColor: WHITE,
        child: CircleAvatar(
          child: Image(image: AssetImage(avatarPath)),
          radius: 30.0,
        ),
      ),
    );
  }
}

class _MessagesButtons extends StatefulWidget {
  const _MessagesButtons({
    Key key,
  }) : super(key: key);

  @override
  __MessagesButtonsState createState() => __MessagesButtonsState();
}

class __MessagesButtonsState extends State<_MessagesButtons> {
  bool all = true;

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      children: <Widget>[
        FloatingActionButton(
          onPressed: () => Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Nouveau message!"),
            ),
          ),
          backgroundColor: MAIN_COLOR_DARK,
          elevation: 8.0,
          tooltip: "Envoyer un nouveau message",
          child: Icon(Icons.add_comment),
        )
      ],
      alignment: MainAxisAlignment.end,
      buttonPadding: EdgeInsets.zero,
    );
  }
}
