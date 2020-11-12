import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/models.dart';

class MyAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc bloc =
        BlocProvider.of<AuthenticationBloc>(context);
    final Parent parent = bloc.currentParent;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/avatar.png',
                  height: 100.0,
                ),
                Center(child: Text("${parent.lastName} ${parent.firstName}")),
              ],
            ),
          ),
          Divider(thickness: 1),
          SizedBox(height: MediaQuery.of(context).size.height / 1.75),
          Divider(thickness: 1),
          ListTile(
            leading: Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            ),
            title: Text("Se deconnecter"),
            onTap: () {
              bloc.add(LogoutEvent());
            },
          ),
          Divider(thickness: 1),
          // SizedBox(height: 50.0),
          Center(
            child: Text("Lakkini@2020"),
          )
        ],
      ),
    );
  }
}
