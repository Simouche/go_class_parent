import 'package:flutter/material.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/widgets/my_app_bar.dart';

class PaymentsList extends StatelessWidget {
  static const String routeName = 'home/payments_page/payments_list';

  @override
  Widget build(BuildContext context) {
    final Payment payment = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: MyAppBar(title: payment.type, showActions: false),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 5.0),
          Expanded(
            child: ListView.separated(
              itemCount: payment.paids.length,
              separatorBuilder: (context, index) => const Divider(thickness: 1),
              itemBuilder: (context, index) => Center(
                child: Material(
                  elevation: 8.0,
                  child: ListTile(
//                    tileColor: Colors.green[100],
                    title: Text(
                      "Somme: ${payment.paids[index].paid} DZD",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    subtitle: Text(
                      "Effectué le: ${payment.paids[index].date}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
