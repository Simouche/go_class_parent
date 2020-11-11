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
    return Scaffold(
      appBar: MyAppBar(title: "Messages", showActions: false),
      // drawer: MyAppDrawer(),
      body: BlocConsumer<MessagesBloc, MessagesState>(
        listener: (context, state) {
          if (state is OpenConversationState)
            Navigator.of(context)
                .pushReplacementNamed(ConversationDialog.routeName);
        },
        builder: (context, state) {
          if (state is MessagesLoaded) {
            MessagesLoaded newState = state;
            return MessagesBody(data: newState.messages);
          } else if (state is MessagesLoading) {
            return Center(child: Text("Chargement des messages."));
          } else if (state is MessagesLoadingFailed) {
            return Center(
                child: Text(
                    "Échec du chargement de vos messages, réessayez plus tard"));
          } else {
            // Navigator.of(context).pop();
            return Center(child: Text("Veuillez recharger"));
          }
        },
      ),
    );
  }
}

class MessagesBody extends StatefulWidget {
  MessagesBody({
    Key key,
    this.data,
  }) : super(key: key) {
    _children = data[1];
    List<Teacher> teachers = List();
    _children.forEach((element) {
      element.teacherAndMatiere.forEach((element) {
        teachers.add(element.teacher);
      });
    });
    List<Director> directors = List();
    _children.forEach((element) {
      directors.add(element.director);
    });
    //Teachers with conversations filter
    _conversations = TeacherWithMessages.filterTeachersWithMessages(
        teachers: teachers, messages: data[0]);
    _conversations =
        _conversations.where((item) => item.messages.isNotEmpty).toList();
    //Director with conversations filter
    _directorConversation = DirectorWithMessages.filterDirectorWithMessages(
        directors: directors, messages: data[0]);
    _directorConversationOnGoing = _directorConversation
        .where((element) => element.messages.isNotEmpty)
        .toList();

    //CEO with conversations filter
    ceo = data[2];
    _ceoWithMessages =
        CeoWithMessages.filterCeoWithMessages(ceo: ceo, messages: data[0]);
  }

  List<StudentWithTeachersAndMatieres> _children;

  final List<dynamic> data;
  List<TeacherWithMessages> _conversations;
  List<DirectorWithMessages> _directorConversation;
  List<DirectorWithMessages> _directorConversationOnGoing;
  CeoWithMessages _ceoWithMessages;
  CEO ceo;

  @override
  _MessagesBodyState createState() => _MessagesBodyState();
}

class _MessagesBodyState extends State<MessagesBody> {
  get dropDownMenuItems => List.generate(
      widget._children.length,
      (index) => DropdownMenuItem(
          value: index,
          child: Text(widget._children[index].student.toString())));

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
                        OpenConversationEvent(ceo: widget._ceoWithMessages)),
                    child: _AdminAvatar(
                      adminName: "CEO",
                      avatarPath: "assets/ceo_avatar.png",
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<MessagesBloc>(context).add(
                          OpenConversationEvent(
                              director: widget._directorConversation?.first ??
                                  DirectorWithMessages(
                                      director: widget
                                          ._children[currentChild].director)));
                    },
                    child: _AdminAvatar(
                        adminName: "Directeur",
                        avatarPath: "assets/admin_avatar.png"),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(left: 10.0),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          widget
                              ._children[currentChild].teacherAndMatiere.length,
                          (index) => Container(
                            margin: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      TeacherWithMessages teacher;
                                      if (widget._conversations.isNotEmpty &&
                                          widget._conversations.length > index)
                                        teacher = widget._conversations[index];
                                      else
                                        teacher = TeacherWithMessages(
                                          teacher: widget
                                              ._children[currentChild]
                                              .teacherAndMatiere[index]
                                              .teacher,
                                        );
                                      BlocProvider.of<MessagesBloc>(context)
                                          .add(OpenConversationEvent(
                                              teacher: teacher));
                                    },
                                    child: _ContactsAvatar()),
                                SizedBox(height: 10.0),
                                Text(
                                    'Enseignant de ${widget._children[currentChild].teacherAndMatiere[index].matiere?.label}')
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
            itemCount: widget._conversations.length +
                widget._directorConversationOnGoing.length +
                1,
            separatorBuilder: (context, index) => const Divider(thickness: 1),
            itemBuilder: (context, index) {
              _MessageTile tile;
              if (widget._conversations.length > index) {
                tile = _MessageTile(
                  conversation: widget._conversations[index],
                );
              } else if (index >= widget._conversations.length &&
                  widget._directorConversationOnGoing.length +
                          widget._conversations.length >
                      index) {
                tile = _MessageTile(
                  directorConversation: widget._directorConversationOnGoing[
                      index - widget._conversations.length],
                );
              } else {
                tile = _MessageTile(
                  ceoConversation: widget._ceoWithMessages,
                );
              }
              return Center(
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<MessagesBloc>(context).add(
                        OpenConversationEvent(
                            teacher: widget._conversations[index]));
                  },
                  child: tile,
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
  _MessageTile(
      {Key key,
      this.conversation,
      this.directorConversation,
      this.ceoConversation})
      : super(key: key);

  final TeacherWithMessages conversation;
  final DirectorWithMessages directorConversation;
  final CeoWithMessages ceoConversation;

  @override
  Widget build(BuildContext context) {
    final String name = conversation?.teacher?.toString() ??
        directorConversation?.director?.toString() ??
        ceoConversation?.ceo?.toString();

    final Message message = conversation?.messages?.last ??
        directorConversation?.messages?.last ??
        ceoConversation?.messages?.last;

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
          !(message.seen ?? false)
              ? CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text(
                    "1",
                    style: TextStyle(color: WHITE, fontSize: 10.0),
                  ),
                  radius: 8.0,
                )
              : Text(""),
        ],
      ),
      onTap: () => BlocProvider.of<MessagesBloc>(context).add(
          OpenConversationEvent(
              teacher: conversation,
              ceo: ceoConversation,
              director: directorConversation)),
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
