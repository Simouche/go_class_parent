import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/values/dimensions.dart';
import 'package:go_class_parent/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import 'new_message_page.dart';

class ConversationDialog extends StatelessWidget {
  static const String routeName = 'home/messages/conversation_dialog';

  WithMessagesMixin conversation;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesBloc, MessagesState>(
      buildWhen: (oldState, newState) {
        return newState is OpenConversationState;
      },
      builder: (context, state) {
        OpenConversationState newState = state;
        conversation = newState.conversation;
        Parent currentUser =
            BlocProvider.of<AuthenticationBloc>(context).currentParent;
        Future.delayed(Duration(seconds: 0), () {
          if (_scrollController.hasClients)
            _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut);
        });
        return Scaffold(
          appBar: MyAppBar(
            showActions: false,
            title: conversation.getName(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              BlocProvider.of<MessagesBloc>(context)
                  .add(OpenNewMessageEvent(contactID: conversation.toString()));
            },
            child: Icon(Icons.edit),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<DownloadsBloc, DownloadsState>(
                  listener: (context, state) {
                if (state is DownloadsInProgressState) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Telechargement en cours..."),
                  ));
                } else if (state is DownloadsSuccessfulState)
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Fichiers telechargés avec succés, veuillez voir la"
                        " pages des telechargement"),
                  ));
              }),
              BlocListener<MessagesBloc, MessagesState>(
                listener: (context, state) {
                  if (state is OpenNewMessageState) {
                    Navigator.of(context).pushNamed(NewMessagePage.routeName,
                        arguments: conversation.getType());
                  }
                },
              ),
            ],
            child: conversation.length() != 0
                ? ListView(
                    controller: _scrollController,
                    children: List.generate(
                      conversation.length(),
                      (index) {
                        return currentUser.serverId ==
                                conversation.getMessages()[index].senderId
                            ? selfMessage(conversation.getMessages()[index])
                            : ContactMessage(
                                message: conversation.getMessages()[index]);
                      },
                    ),
                  )
                : Center(
                    child: Text("Pas de Message dans la Conversation"),
                  ),
          ),
        );
      },
    );
  }

  Widget selfMessage(Message message) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.fromLTRB(100.0, 20.0, 5.0, 1.0),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                ),
                color: MAIN_COLOR_DARK,
              ),
              child: Container(
                child: Html(
                  data: "<div>" + message.message + "</div>",
                  style: {
                    "div": Style(
                      color: WHITE,
                    ),
                  },
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${message.date} ${message.time}"),
              SizedBox(width: 3.0),
              !message.approved
                  ? Icon(Icons.check, color: Colors.black)
                  : Icon(
                      Icons.done_all,
                      color: Colors.black,
                    ),
            ],
          )
        ],
      );
}

class ContactMessage extends StatelessWidget {
  const ContactMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async {
          if (message.fileUrl.isEmpty) {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("Aucun fichier a telecharger")));
          } else if (message.downloaded) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Fichier déja telechargé,"
                    " veuillez consultez la page des telechargements."),
              ),
            );
          } else {
            if (await Permission.storage.request().isGranted) {
              BlocProvider.of<DownloadsBloc>(context)
                  .add(TriggerDownloadsEvent(files: message.fileUrl));
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Permission refusée"),
              ));
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.fromLTRB(5.0, 20.0, 100.0, 1.0),
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                  color: Colors.grey[200],
                ),
                child: Container(
                  child: Html(data: message.message),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_download,
                  color: message.fileUrl?.isNotEmpty ?? false
                      ? MAIN_COLOR_LIGHT
                      : Colors.grey,
                ),
                Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text("${message.date} ${message.time}")),
              ],
            )
          ],
        ),
      );
}

class BottomSheet extends StatelessWidget {
  BottomSheet({Key key, this.teacher}) : super(key: key);

  final teacher;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final messageInputController = TextEditingController();
    final subjectInputController = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        color: WHITE,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            color: MAIN_COLOR_DARK,
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "New Message",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: WHITE),
                ),
                SizedBox(width: 5.0),
                Image(
                  image: AssetImage("assets/ic_message.png"),
                  height: 32.0,
                  width: 32.0,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 2.0, top: 2.0),
            width: 300.0,
            child: TextFormField(
              cursorColor: colorScheme.onSurface,
              controller: subjectInputController,
              decoration: InputDecoration(
                labelText: "Subject",
                labelStyle: TextStyle(letterSpacing: mediumLetterSpacing),
              ),
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 5.0, left: 5.0),
            margin: EdgeInsets.only(top: 5.0),
            color: Colors.grey[200],
            child: TextFormField(
              maxLines: 8,
              keyboardType: TextInputType.multiline,
              cursorColor: colorScheme.onSurface,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: "Message",
                labelStyle: TextStyle(letterSpacing: mediumLetterSpacing),
              ),
              controller: messageInputController,
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: WHITE,
                  child: Icon(Icons.attach_file, color: MAIN_COLOR_DARK),
                  onPressed: () {},
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / 33,
                    left: 10.0,
                  ),
                  child: FloatingActionButton(
                    backgroundColor: MAIN_COLOR_LIGHT,
                    child: Icon(Icons.send, color: WHITE),
                    onPressed: () {
                      BlocProvider.of<MessagesBloc>(context).add(
                        SendMessageEvent(
                          Message(
                            subject: subjectInputController.text,
                            message: messageInputController.text,
                            senderId:
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .currentUser
                                    .serverId,
                            receiverId: teacher.serverId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
