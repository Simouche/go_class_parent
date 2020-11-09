import 'package:flutter/material.dart';
import 'package:go_class_parent/backend/models/models.dart';
import 'package:go_class_parent/widgets/widgets.dart';
import 'package:hexcolor/hexcolor.dart';

class CanteenList extends StatelessWidget {
  static const String routeName = 'home/canteen_page/canteen_list';

  final List<String> days = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi'];

  @override
  Widget build(BuildContext context) {
    final Canteen canteen = ModalRoute.of(context).settings.arguments;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: MyAppBar(
          title: "Cantine",
          tabBar: TabBar(
              unselectedLabelColor: Colors.lightBlueAccent,
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.lightBlueAccent, Colors.greenAccent]),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.redAccent),
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: Colors.lightBlueAccent, width: 1),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Dim"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: Colors.lightBlueAccent, width: 1),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Lun"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: Colors.lightBlueAccent, width: 1),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Mar"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: Colors.lightBlueAccent, width: 1),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Mer"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.lightBlueAccent, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Jeu"),
                    ),
                  ),
                ),
              ]),
        ),
        body: TabBarView(
          children: <Widget>[
            _MenuDetails(menu: canteen.menus[0]),
            _MenuDetails(menu: canteen.menus[1]),
            _MenuDetails(menu: canteen.menus[2]),
            _MenuDetails(menu: canteen.menus[3]),
            _MenuDetails(menu: canteen.menus[4]),
          ],
        ),
      ),
    );
  }
}

class _MenuDetails extends StatelessWidget {
  final Menu menu;

  const _MenuDetails({Key key, this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          if (index == 0) {
            return _cardDetailBuilder(
                'Plat Principale: ', menu.plats.first, "646DE0", "6E81E4");
          } else if (index == 1) {
            return _cardDetailBuilder(
                'Plat Secondaire: ', menu.plats.second, "646DE0", "6E81E4");
          } else {
            return _cardDetailBuilder(
                'Dessert: ', menu.plats.dessert, "646DE0", "6E81E4");
          }
        },
        separatorBuilder: (context, index) => const Divider(thickness: 1),
        itemCount: 3);
  }

  Widget _cardDetailBuilder(
      String titleTxt, String meals, String startColor, String endColor) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
//        height: MediaQuery.of(context).size.height / 4,
//        width: MediaQuery.of(context).size.width / 2.5,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: HexColor(endColor).withOpacity(0.6),
                        offset: Offset(1.1, 4.0),
                        blurRadius: 8.0),
                  ],
                  gradient: LinearGradient(
                    colors: <HexColor>[
                      HexColor(startColor),
                      HexColor(endColor),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(54.0),
                    bottomLeft: Radius.circular(54.0),
                    topLeft: Radius.circular(54.0),
                    topRight: Radius.circular(54.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 54,
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        titleTxt,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.2,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  meals,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
