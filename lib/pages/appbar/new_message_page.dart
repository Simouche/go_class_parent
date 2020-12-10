import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/values/Colors.dart';
import 'package:go_class_parent/values/dimensions.dart';
import 'package:intl/intl.dart';

class NewMessagePage extends StatelessWidget {
  static const String routeName =
      'home/messages/conversation_dialog/new_message';

  NewMessagePage({Key key}) : super(key: key);

  String contactID;
  int type;
  Message messageSent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final messageInputController = TextEditingController();
    final subjectInputController = TextEditingController();
    List<File> files;
    type = ModalRoute.of(context).settings.arguments;

    return BlocBuilder<MessagesBloc, MessagesState>(
        buildWhen: (oldState, newState) {
      return newState is OpenNewMessageState;
    }, builder: (context, state) {
      contactID = (state as OpenNewMessageState).contactID;

      return Scaffold(
        body: BlocListener<MessagesBloc, MessagesState>(
          listener: (context, state) {
            if (state is MessageSending) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("Envoi de message")));
            } else if (state is MessageSendFailed) {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Echec de l'envoi, reessayez plutard.")));
              // Navigator.of(context).pop();
            } else if (state is MessageSent) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text("Message Envoyé!")));
              BlocProvider.of<MessagesBloc>(context).add(
                OpenConversationEvent(
                  contactID: contactID,
                  type: type,
                ),
              );
              Navigator.of(context).pop();
            }
          },
          child: SafeArea(
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
                        "Nouveau Message",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0, color: WHITE),
                      ),
                      SizedBox(width: 5.0),
//                      Image(
//                        image: AssetImage("assets/ic_message.png"),
//                        height: 32.0,
//                        width: 32.0,
//                      )
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
                      labelText: "Sujet",
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
//                      FloatingActionButton(
//                        heroTag: "Button1",
//                        backgroundColor: WHITE,
//                        child: Icon(Icons.attach_file, color: MAIN_COLOR_DARK),
//                        onPressed: () async {
//                          FilePickerResult result = await FilePicker.platform
//                              .pickFiles(allowMultiple: true);
//                          if (result != null) {
//                            print(result.paths);
//                            files =
//                                result.paths.map((path) => File(path)).toList();
//                            // Scaffold.of(context).showSnackBar(
//                            //     SnackBar(content: Text("Files Selected")));
//                          }
//                        },
//                      ),
                      Container(
                        margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 33,
                          left: 10.0,
                        ),
                        child: FloatingActionButton(
                          heroTag: "button2",
                          backgroundColor: MAIN_COLOR_LIGHT,
                          child: Icon(Icons.send, color: WHITE),
                          onPressed: () async {
                            messageSent = Message(
                                subject: subjectInputController.text,
                                message: messageInputController.text,
                                senderId:
                                    (await BlocProvider.of<AuthenticationBloc>(
                                                context)
                                            .parent)
                                        .serverId,
                                receiverId: contactID,
                                date: DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now())
                                    .toString(),
                                time: DateFormat('kk:mm:ss')
                                    .format(DateTime.now()));
                            BlocProvider.of<MessagesBloc>(context).add(
                              SendMessageEvent(
                                messageSent,
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
          ),
        ),
      );
    });
  }
}
