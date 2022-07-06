import 'package:flutter/material.dart';
import '../../../helper/responsive_helper.dart';
import '../../base/app_bar_base.dart';
import '../../base/web_app_bar/web_app_bar.dart';
import '../cart/cart_screen.dart';
import '../order/my_order_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs_screen';
  static int routeIndex=0;

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
//  var currentPage = DrawerSection.
  final List<Map<String, Object>> _page = [
    {
      'page': CartScreen(),
      'title': 'cart',
    },
    {
      'page': MyOrderScreen(),
      'title': 'order',
    },
  ];
  int _selectPageIndex = 0;

 void _selectPage(int value) {
   setState(() {
     _selectPageIndex = value;
   });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Theme.of(context).primaryColor,
//       drawer: MainDrawer(),
      appBar: ResponsiveHelper.isMobilePhone()? null
          : ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(),
          preferredSize: Size.fromHeight(120)) : AppBarBase(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: purpleColor,
//        color: Theme.of(context).primaryColor.withOpacity(0),
        child: _page[TabsScreen.routeIndex]['page'],
      ),
     bottomNavigationBar: BottomNavigationBar(
       selectedFontSize: 20,
       // backgroundColor: purpleColor,
       selectedItemColor: Theme.of(context).colorScheme.primary,
       // unselectedItemColor: KTextColor.shade300,
       currentIndex: TabsScreen.routeIndex,
       onTap: _selectPage,
       items: [
         BottomNavigationBarItem(
           icon: Icon(Icons.local_library, size: 25),
           label: 'المنهج',
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.description, size: 25),
           label: 'المراجعه',
         ),
       ],
     ),
    );
  }
}
