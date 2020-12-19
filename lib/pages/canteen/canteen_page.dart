import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/widgets/widgets.dart';

import 'canteen_list.dart';

class CanteenPage extends StatelessWidget {
  static const String routeName = 'home/canteen_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Cantines', showActions: false),
      body: BlocBuilder<CanteenBloc, CanteenState>(
        buildWhen: (context, state) =>
            state is CanteenLoadedState ||
            state is CanteenLoadingFailedState ||
            state is CanteenLoadingState,
        builder: (context, state) {
          if (state is CanteenLoadingState) {
            return Center(child: Text('En cours de chargement.'));
          } else if (state is CanteenLoadingFailedState) {
            return Center(
                child: Text('Echec de chargement, reessayez plutard.'));
          } else if (state is CanteenLoadedState) {
            if (state.canteens.isEmpty) {
              return Center(child: Text('Aucune information a affiché.'));
            } else if (state.canteens.length == 1) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.pushReplacementNamed(
                  context,
                  CanteenList.routeName,
                  arguments: state.canteens.first,
                );
              });
              return Center(child: Text('Chargé, un moment svp.'));
            } else {
              return _CanteenPageBody(canteens: state.canteens);
            }
          } else {
            Navigator.of(context).pop();
            return Center(child: Text('Chargement...'));
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class _CanteenPageBody extends StatefulWidget {
  List<Canteen> canteens = List();
  String currentClass;

  _CanteenPageBody({this.canteens}) {
    currentClass = canteens.first.classe;
  }

  @override
  __CanteenPageBodyState createState() => __CanteenPageBodyState();
}

class __CanteenPageBodyState extends State<_CanteenPageBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          // Center(
          //   child: CustomDropdownButton(
          //     items: dropDownMenuItems,
          //     onChanged: (newValue) {
          //       setState(() {
          //         widget.currentClass = newValue;
          //       });
          //     },
          //     value: widget.currentClass,
          //   ),
          // ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                widget.canteens.length,
                (index) => GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      CanteenList.routeName,
                      arguments: widget.canteens[index],
                    );
                  },
                  child: Card(
                    elevation: 8.0,
                    shadowColor: Color(0x802196F3),
                    margin: EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            widget.canteens[index].classe,
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  get dropDownMenuItems => List.generate(
        widget.canteens.length,
        (index) => DropdownMenuItem(
          value: widget.canteens[index].classe,
          child: Center(
            child: Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              color: Colors.grey[50],
              child: Text(
                widget.canteens[index].classe,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ),
      );

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
}
