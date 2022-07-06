import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/html_type.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/banner_provider.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/wishlist_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/base/title_widget.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_grocery/view/screens/address/address_screen.dart';
import 'package:flutter_grocery/view/screens/cart/cart_screen.dart';
import 'package:flutter_grocery/view/screens/category/all_category_screen.dart';
import 'package:flutter_grocery/view/screens/chat/chat_screen.dart';
import 'package:flutter_grocery/view/screens/coupon/coupon_screen.dart';
import 'package:flutter_grocery/view/screens/home/widget/banners_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/category_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/home_item_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/product_view.dart';
import 'package:flutter_grocery/view/screens/html/html_viewer_screen.dart';
import 'package:flutter_grocery/view/screens/order/my_order_screen.dart';
import 'package:flutter_grocery/view/screens/settings/setting_screen.dart';
import 'package:flutter_grocery/view/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

import '../menu/menu_screen.dart';
import 'body_home _screens.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentindex = 0;

  Future<void> _loadData(BuildContext context, bool reload) async {
    Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
      context,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
      reload,
    );

    Provider.of<BannerProvider>(context, listen: false)
        .getBannerList(context, reload);

    await Provider.of<ProductProvider>(context, listen: false).getDailyNeeds(
      context,
      '1',
      true,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
    );

    Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
      context,
      '1',
      true,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
    );

    Provider.of<ProductProvider>(context, listen: false).getLatestProductList(
      context,
      '1',
      true,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
    );
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      await Provider.of<WishListProvider>(context, listen: false)
          .getWishList(context);
    }
  }

  @override
  void initState() {
    _loadData(context, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<ProductProvider>(context, listen: false).offset = 1;
        Provider.of<ProductProvider>(context, listen: false).popularOffset = 1;
        await _loadData(context, true);
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: Scaffold(
        bottomNavigationBar:BottomNavigationBar(
            currentIndex: currentindex,
            onTap: (index) {
              currentindex = index;
              setState(() {});
            },

            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home,color: Theme.of(context).primaryColor,), label: getTranslated('home', context)),
              BottomNavigationBarItem(
                  icon: Stack(clipBehavior: Clip.none, children: [
                    Image.asset(Images.order_bag,
                        color: Theme.of(context).primaryColor,
                       // color: Theme.of(context).textTheme.bodyText1.color,
                        width: 25,
                        height: 25),
                    Positioned(
                      top: -7,
                      right: -2,
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor),
                        child: Text(
                            '${Provider.of<CartProvider>(context).cartList.length}',
                            style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontSize: 10)),
                      ),
                    ),
                  ]),
                  label: getTranslated('shopping_bag', context),),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    Images.order_list,
                    width: 25,
                    height: 25,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: getTranslated('my_order', context)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.read_more,color:Theme.of(context).primaryColor,), label: getTranslated('more', context),),
            ]),
        appBar: ResponsiveHelper.isDesktop(context)
            ? PreferredSize(
                child: Column(
                  children: [
                    WebAppBar(),
                  ],
                ), preferredSize: Size.fromHeight(120))
            : null,

        body:currentindex==0?
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 1170,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: ResponsiveHelper.isDesktop(context)
                                  ? MediaQuery.of(context).size.height - 400
                                  : MediaQuery.of(context).size.height),
                          child: Column(children: [
                            Consumer<BannerProvider>(
                                builder: (context, banner, child) {
                              return banner.bannerList == null
                                  ? BannersView()
                                  : banner.bannerList.length == 0
                                      ? SizedBox()
                                      : BannersView();
                            }),

                            // Category
                            Consumer<CategoryProvider>(
                                builder: (context, category, child) {
                              return category.categoryList == null
                                  ? CategoryView()
                                  : category.categoryList.length == 0
                                      ? SizedBox()
                                      : CategoryView();
                            }),

                            // Category
                            SizedBox(
                                height: ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.PADDING_SIZE_LARGE
                                    : 0),

                            /* TitleWidget(title: getTranslated('daily_needs', context) ,onTap: () {
                              Navigator.pushNamed(context, RouteHelper.getHomeItemRoute('daily_needs'));
                            }),
                           /* Consumer<ProductProvider>(builder: (context, product, child) {
                              return product.dailyItemList == null ? HomeItemView(isDailyItem: true) : product.dailyItemList.length == 0
                                  ? SizedBox() : HomeItemView(isDailyItem: true);
                            }),*/

                            TitleWidget(title: getTranslated('popular_item', context) ,onTap: () {
                              Navigator.pushNamed(context, RouteHelper.getHomeItemRoute('popular_item'));
                            }),*/

                            /* Consumer<ProductProvider>(builder: (context, product, child) {
                              return product.latestProductList == null ? HomeItemView(isDailyItem: false) : product.latestProductList.length == 0
                                  ? SizedBox() : HomeItemView(isDailyItem: false);
                            }),*/

                            /*  ResponsiveHelper.isMobilePhone() ? SizedBox(height: 10) : SizedBox.shrink(),
                            TitleWidget(title: getTranslated('latest_items', context)),
                            ProductView(scrollController: _scrollController),*/
                          ]),
                        ),
                      ),
                    ),
                    ResponsiveHelper.isDesktop(context)
                        ? FooterView()
                        : SizedBox(),
                  ],
                ),
              ),
            ),

          ],
        ):
        views[currentindex]
      ),
    );
  }

  List<Widget> views = [
    HomeScreen(),
    CartScreen(),
    MyOrderScreen(),
    MenuWidget(),
   /* AllCategoryScreen(),
    WishListScreen(),
    AddressScreen(),
    CouponScreen(),
    ChatScreen(),
    SettingsScreen(),
    HtmlViewerScreen(htmlType: HtmlType.TERMS_AND_CONDITION),
    HtmlViewerScreen(htmlType: HtmlType.PRIVACY_POLICY),
    HtmlViewerScreen(htmlType: HtmlType.ABOUT_US),*/
  ];
}
