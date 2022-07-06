import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/provider/banner_provider.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/view/screens/home/widget/category_view.dart';
import 'package:provider/provider.dart';

import '../../../utill/dimensions.dart';
import '../../base/footer_view.dart';
import 'widget/banners_view.dart';

class BodyHomeScreens extends StatefulWidget {
  @override
  State<BodyHomeScreens> createState() => _BodyHomeScreensState();
}

class _BodyHomeScreensState extends State<BodyHomeScreens> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
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


    );
  }
}
