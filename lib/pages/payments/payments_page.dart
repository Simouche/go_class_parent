import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_class_parent/backend/blocs/blocs.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/widgets/widgets.dart';

import 'payments_list.dart';

class PaymentsPage extends StatelessWidget {
  static const String routeName = 'home/payments_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Paiements",
        showActions: false,
      ),
      body: BlocBuilder<PaymentsBloc, PaymentsState>(
        buildWhen: (context, state) =>
            state is PaymentsLoadingFailed ||
            state is PaymentsLoading ||
            state is PaymentsLoaded,
        builder: (context, state) {
          if (state is PaymentsLoadingFailed) {
            return Center(
                child: Text('Echec de chargement, reessayez plutard.'));
          } else if (state is PaymentsLoading) {
            return Center(child: Text('En cours de chargement.'));
          } else if (state is PaymentsLoaded) {
            if (state.payments.isEmpty)
              return Center(child: Text('Aucun Paiement a affiché.'));
            else
              return _PaymentsPageBody(payments: state.payments);
          } else {
            Navigator.of(context).pop();
            return null;
          }
        },
      ),
    );
  }
}

class _PaymentsPageBody extends StatefulWidget {
  Map<String, List<Payment>> payments = Map();
  String currentChild;

  _PaymentsPageBody({this.payments}) {
    currentChild = payments.keys.first;
  }

  @override
  __PaymentsPageBodyState createState() => __PaymentsPageBodyState();
}

class __PaymentsPageBodyState extends State<_PaymentsPageBody> {
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
          Center(
            child: CustomDropdownButton(
              items: dropDownMenuItems,
              onChanged: (newValue) {
                setState(() {
                  widget.currentChild = newValue;
                });
              },
              value: widget.currentChild,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                widget.payments[widget.currentChild].length,
                (index) => _buildTile(
                  Container(
                    width: (MediaQuery.of(context).size.width / 2) - 30,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            widget.payments[widget.currentChild][index].type,
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      PaymentsList.routeName,
                      arguments: widget.payments[widget.currentChild][index],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  get dropDownMenuItems => List.generate(
        widget.payments.keys.length,
        (index) => DropdownMenuItem(
          value: widget.payments.keys.toList()[index],
          child: Center(
            child: Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              color: Colors.grey[50],
              child: Text(
                widget.payments.keys.toList()[index],
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
