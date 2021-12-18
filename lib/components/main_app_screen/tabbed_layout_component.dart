import 'package:flutter/material.dart';

class TabbedLayoutComponent extends StatefulWidget {
  const TabbedLayoutComponent({Key? key}) : super(key: key);
  @override
  _TabbedLayoutComponentState createState() =>
      new _TabbedLayoutComponentState();
}

class _TabbedLayoutComponentState extends State<TabbedLayoutComponent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // extendBodyBehindAppBar: true,
      bottomNavigationBar: menu(),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
            child: Icon(Icons.directions_car),
          ),
          Container(child: Icon(Icons.directions_transit)),
          Container(child: Icon(Icons.directions_bike)),
          Container(child: Icon(Icons.directions_bike)),
        ],
      ),
    );
    // );
  }

  Widget menu() {
    return SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: Container(
      color: Color(0xFFFFFFFF),
      child: TabBar(
        // isScrollable: true,
        controller: _tabController,
        labelColor: Color(0xFF0070BA),
        unselectedLabelColor: Color(0xFF243656),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.white,

        tabs: [
          Tab(
            icon: Icon(
              Icons.home_outlined,
              size: 36,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.people_alt,
              size: 36,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.account_balance_wallet_outlined,
              size: 36,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.settings_outlined,
              size: 36,
            ),
          ),
        ],
      ),
      height: 70,
    )
        // height: 100,
        // width: double.infinity,
        );
  }
}
