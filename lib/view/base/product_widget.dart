
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/product_type.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/on_hover.dart';
import 'package:flutter_grocery/view/base/rating_bar.dart';
import 'package:provider/provider.dart';


import '../screens/product/widget/web_product_information.dart';
import 'wish_button.dart';

class ProductWidget extends StatefulWidget {
  final Product product;
  final ProductType productType;
  final bool isGrid;
  final int stock;
  final int cartIndex;
  final ProductProvider productProvider;

  ProductWidget({@required this.product, this.productType = ProductType.DAILY_ITEM, this.isGrid = false, @required this.stock,@required this.cartIndex , @required this.productProvider});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  double changeString(String string){
    double string1 =double.parse(string);
    return string1;
  }
  final oneSideShadow = Padding(
    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
    child: Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: ColorResources.Black_COLOR.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
    ),
  );
  String dropdownValue = 'Piece';
  double  box = 1;
  @override
  Widget build(BuildContext context ) {
    /*if(widget.product.variations.isNotEmpty)*/
    //double discountBox = double.parse(widget.product.variations.single.type);

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child ) {
        double _price = 0;
        int _stock = 0;
        bool isExistInCart = false;
        int cardIndex;
        CartModel _cartModel;
        if(cartProvider.cartList != null) {
          if(widget.product.variations.length > 0) {
            for(int index=0; index<widget.product.variations.length; index++) {
              _price = widget.product.variations.length > 0 ? widget.product.variations[index].price : widget.product.price;
              _stock = widget.product.variations.length > 0 ? widget.product.variations[index].stock : widget.product.totalStock;
              _cartModel = CartModel(widget.product.id, widget.product.image.isNotEmpty ? widget.product.image[0] : '', widget.product.name, _price,
                  PriceConverter.convertWithDiscount(
                      context, _price, widget.product.discount, widget.product.discountType),
                  1,
                  widget.product.variations.length > 0 ? widget.product.variations[index] : null,
                  (_price - PriceConverter.convertWithDiscount(context, _price, widget.product.discount, widget.product.discountType)),
                  (_price - PriceConverter.convertWithDiscount(context, _price, widget.product.tax, widget.product.taxType)),
                  widget.product.capacity,
                  widget.product.unit,
                  _stock,widget.product
              );
              isExistInCart = Provider.of<CartProvider>(context, listen: false).isExistInCart(_cartModel) != null;
              cardIndex = Provider.of<CartProvider>(context, listen: false).isExistInCart(_cartModel);
              if(isExistInCart) {
                break;
              }
            }
          }else {
            _price = widget.product.variations.length > 0 ? widget.product.variations[0].price : widget.product.price;
            _stock = widget.product.variations.length > 0 ? widget.product.variations[0].stock : widget.product.totalStock;
            _cartModel = CartModel(widget.product.id, widget.product.image.isNotEmpty ?  widget.product.image[0] : '', widget.product.name, _price,
                PriceConverter.convertWithDiscount(
                    context, _price, widget.product.discount, widget.product.discountType),
                1,
                widget.product.variations.length > 0 ? widget.product.variations[0] : null,
                (_price - PriceConverter.convertWithDiscount(context, _price, widget.product.discount, widget.product.discountType)),
                (_price - PriceConverter.convertWithDiscount(context, _price, widget.product.tax, widget.product.taxType)),
                widget.product.capacity,
                widget.product.unit,
                _stock,widget.product
            );
            isExistInCart = Provider.of<CartProvider>(context, listen: false).isExistInCart(_cartModel) != null;
            cardIndex = Provider.of<CartProvider>(context, listen: false).isExistInCart(_cartModel);
          }
        }

        return ResponsiveHelper.isDesktop(context) ? OnHover(
          isItem: true,
          child: _productGridView(context, isExistInCart, _stock, _cartModel, cardIndex),
        ) : widget.isGrid ? _productGridView(context, isExistInCart, _stock, _cartModel, cardIndex) :
        Padding(
          padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                RouteHelper.getProductDetailsRoute(product: widget.product),
              );
            },
            child: Container(
              width: 120,
              height: 120,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorResources.getCardBgColor(context),
              ),
              child: Row(children: [
                Container(
                  height: 85,
                  width: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2,
                        color: ColorResources.getGreyColor(context)),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholder(context),
                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${
                          widget.product.image.isNotEmpty ? widget.product.image[0] : ''}',
                      fit: BoxFit.cover,
                      width: 85,
                      height: 120,
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), width: 85, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.product.name,
                            style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),


                          widget.product.rating != null ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: RatingBar(rating: widget.product.rating.length > 0 ? double.parse(widget.product.rating[0].average) : 0.0, size: 10),
                          ) : SizedBox(),

                          Text('${widget.product.capacity} ${widget.product.unit}',
                              style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                  color: ColorResources.getTextColor(context))),


                          Row(children: [
                            Text('ربحية' ,style: poppinsBold.copyWith(fontSize:14 /*Dimensions.FONT_SIZE_SMALL*/, color:Theme.of(context).primaryColor), ),
                            /*widget.product.discountType=='amount'?Text(box==1||widget.product.variations.isEmpty?'${widget.product.discount} جنيه مصري ':
                '${discountBox} جنيه مصري ',
                    style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)):*/
                            widget.product.discount > 0 ? Text( box==1||widget.product.variations.isEmpty?
                            '${PriceConverter.convertPrice(context,widget.product.discount)}':
                            '${PriceConverter.convertPrice(context,
                                (changeString(widget.product.variations.single.type)))}',
                            /*'${widget.product.discount} جنيه مصري'*//*'${PriceConverter.convertPrice(context,widget.product.price ,
                                discount:((widget.product.price)-(widget.product.discount)) , discountType: widget.product.discountType )}':
                            '${PriceConverter.convertPrice(context,widget.product.price ,
                                discount:((widget.product.variations.single.price)-(changeString(widget.product.variations.single.type))) , discountType: widget.product.discountType )}',*/
                              style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                            ) : SizedBox(),
                            /*Text('ربحية' ,style: poppinsBold.copyWith(fontSize:14 /*Dimensions.FONT_SIZE_SMALL*/, color:Theme.of(context).primaryColor), ),
                            widget.product.discount > 0 ? Text( box==1||widget.product.variations.isEmpty?
                            '${widget.product.discount} جنيه مصري':
                            '${widget.product.variations.single.type} جنيه مصري',
                              style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                            ) : SizedBox(),*/
                            /*Text('ربحية' ,style: poppinsBold.copyWith(fontSize:14 /*Dimensions.FONT_SIZE_SMALL*/, color:Theme.of(context).primaryColor), ),
                            widget.product.discountType=='amount'?Text('${widget.product.discount} جنيه مصري ',
                                style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)):
                            widget.product.discount > 0 ? Text( box==1||widget.product.variations.isEmpty?
                            '${PriceConverter.convertPrice(context,widget.product.price ,
                                discount: widget.product.discount, discountType: 'profitability' )}':
                            '${PriceConverter.convertPrice(context,widget.product.variations.single.price ,
                                discount: widget.product.discount, discountType: 'profitability')}',
                              style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                            ) : SizedBox(),*/

                           // product.discount > 0 ? SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL) : SizedBox(),

                          ],),

                         Row(

                           children: [
                             Text(
                                 box==1||widget.product.variations.isEmpty ? '${PriceConverter.convertPrice(
                                 context, widget.product.price, discount: widget.product.discount, discountType: widget.product.discountType)}': '${PriceConverter.convertPrice(
                                     context, widget.product.variations.single.price, discount: changeString(widget.product.variations.single.type), discountType: widget.product.discountType)}',

                               style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                             ),
                           ],
                         ),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 85,
                                  height: 60,
                                  padding: EdgeInsets.all(2),
                                  margin: EdgeInsets.all(2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: ColorResources.getHintColor(context).withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Consumer<ProductProvider>(
                                    builder: (context, productProvider, child) {

                                      return  Container(
                                        padding: EdgeInsetsDirectional.all(10),
                                        alignment: Alignment.bottomLeft,
                                        child: DropdownButton<String>(
                                         /*onTap: (){

                                            if(dropdownValue=='Piece'){
                                              box=1;
                                            }else {
                                              box=0;
                                            }
                                            setState(() {});
                                          },*/


                                          value: dropdownValue,
                                          /*icon: const Icon(Icons.arrow_downward),*/
                                          //elevation: 16,
                                          style: const TextStyle(color: Color(0xFF01684B)),
                                          underline: Container(
                                            height: 0,
                                            color:Theme.of(context).primaryColor,
                                          ),
                                          onChanged:(String newValue) {
                                            //widget.product.variations==[]?
                                            setState(() {
                                              dropdownValue = newValue;
                                              setState(() {
                                                if(dropdownValue=='Piece'){
                                                  box=1;
                                                }else {
                                                  box=0;
                                                }
                                               // setState(() {});
                                              });
                                            })/*:setState(() {
                                              dropdownValue = 'Piece';
                                              setState(() {
                                                //if(dropdownValue=='Piece'){
                                                  box=1;
                                                //}else {
                                                //  box=0;
                                                //}
                                                // setState(() {});
                                              });
                                            })*/;
                                          },

                                          items:widget.product.variations.isNotEmpty?<String>[ 'Piece','Box' ]
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),

                                            );
                                          }).toList():<String>[ 'Piece' ]
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),

                                            );
                                          }).toList(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ]),

                  ),
                ),

                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: WishButton(product: widget.product, edgeInset: EdgeInsets.all(5)),
                      ),
                      Expanded(child: SizedBox()),

                      if (!isExistInCart) InkWell(
                          onTap: () {
                            if(widget.product.variations == null || widget.product.variations.length == 0) {
                              if (isExistInCart) {
                                showCustomSnackBar(getTranslated('already_added', context), context);
                              } else if (_stock < 1) {
                                showCustomSnackBar(getTranslated('out_of_stock', context), context);
                              } else {
                                Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel);
                                showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                              }
                            }else {
                              Navigator.of(context).pushNamed(
                                RouteHelper.getProductDetailsRoute(product: widget.product),
                              );
                            }
                          },
                           child: Container(
                             width: 30,
                            height: 30,
                            padding: EdgeInsets.all(2),
                            margin: EdgeInsets.all(2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: ColorResources.getHintColor(context).withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                            child: Icon(Icons.add),
                            ),

                            /* child: Consumer<ProductProvider>(
                               builder: (context, productProvider, child) {
                                 return
                                Builder(
                                builder: (context) {
                                  return
                                     Row(children: [
                                      QuantityButton(isIncrement: false, quantity: productProvider.quantity, stock: stock,cartIndex: cartIndex),
                                      SizedBox(width: 15),
                                      Consumer<CartProvider>(builder: (context, cart, child) {
                                        return Text(cartIndex != null ? cart.cartList[cartIndex].quantity.toString()
                                            : productProvider.quantity.toString(), style: poppinsSemiBold);
                                      }),
                                      SizedBox(width: 15 ,  ),
                                      QuantityButton(isIncrement: true, quantity: productProvider.quantity, stock: stock, cartIndex: cartIndex),
                                    ]
                                    );

                                }
                            ); } )*/

                          )
                      ) else Consumer<CartProvider>(builder: (context, cart, child) =>
                          Row(children: [
                            InkWell(
                              onTap: () {
                                if (cart.cartList[cardIndex].quantity > 1) {
                                  Provider.of<CartProvider>(context, listen: false).setQuantity(false, cardIndex, context: context, showMessage: true);
                                } else {
                                  Provider.of<CartProvider>(context, listen: false).removeFromCart(cardIndex, context);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Icon(Icons.remove, size: 20, color: Theme.of(context).primaryColor),
                              ),
                            ),
                            Text(
                                cart.cartList[cardIndex].quantity.toString(),
                                style: poppinsSemiBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                    color: Theme.of(context).primaryColor)),
                            InkWell(
                              onTap: () {
                                if (cart.cartList[cardIndex].quantity <
                                    cart.cartList[cardIndex].stock) {
                                  Provider.of<CartProvider>(context, listen: false).setQuantity(true, cardIndex, context: context, showMessage: true);
                                } else {
                                  showCustomSnackBar(getTranslated('out_of_stock', context), context);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Icon(Icons.add, size: 20, color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ]),
                      ),
                    ]),
              ]),
            ),
          ),
        );
      },
    );
  }

  InkWell _productGridView(BuildContext context, bool isExistInCart, int _stock, CartModel _cartModel, int cardIndex) {
    return InkWell(
          borderRadius:  BorderRadius.circular(Dimensions.RADIUS_SIZE_TEN),
          onTap: () {
            Navigator.of(context).pushNamed(RouteHelper.getProductDetailsRoute(product: widget.product),
            );
          },
          child: Container(
            decoration: BoxDecoration(
            color: ColorResources.getCardBgColor(context),
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_TEN),
            boxShadow: [BoxShadow(
              color: ColorResources.Black_COLOR.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 7,
              spreadRadius: 0.1,
            ),]),
            child: Stack(children: [
              Column(children: [
                Expanded(
                  flex: 6,
                  child: Stack(children: [
                    oneSideShadow,

                    Container(
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorResources.getCardBgColor(context),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.RADIUS_SIZE_TEN),
                          topRight: Radius.circular(Dimensions.RADIUS_SIZE_TEN),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.RADIUS_SIZE_TEN),
                          topRight: Radius.circular(Dimensions.RADIUS_SIZE_TEN),
                        ),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder(context),
                          height: 155,
                          fit: BoxFit.cover,
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${
                              widget.product.image.isNotEmpty ? widget.product.image[0] : ''}',
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), width: 80, height: 155, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ],
                ),),

                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.product.name,
                          style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),

                        widget.product.rating != null ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: RatingBar(rating: widget.product.rating.length > 0 ? double.parse(widget.product.rating[0].average) : 0.0, size: 10),
                        ) : SizedBox(),

                        Text(
                          '${widget.product.capacity} ${widget.product.unit}',
                          style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              PriceConverter.convertPrice(context, widget.product.price, discount: widget.product.discount, discountType: widget.product.discountType),
                              style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                            ),

                            widget.product.discount > 0 ?
                            Text(PriceConverter.convertPrice(context, widget.product.discount), style: poppinsRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                              color: ColorResources.RED_COLOR,
                              decoration: TextDecoration.lineThrough,
                            ),) : SizedBox(height: 15),
                          ],
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                        if(widget.productType == ProductType.LATEST_PRODUCT) Column(children: [
                          !isExistInCart ? InkWell(
                            onTap: () {
                              if(widget.product.variations == null || widget.product.variations.length == 0) {
                                if (isExistInCart) {
                                  showCustomSnackBar(getTranslated('already_added', context), context);
                                } else if (_stock < 1) {
                                  showCustomSnackBar(getTranslated('out_of_stock', context), context);
                                } else {
                                  Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel);
                                  showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                                }
                              }else {
                                Navigator.of(context).pushNamed(
                                  RouteHelper.getProductDetailsRoute(product: widget.product),
                                );
                              }
                            },
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated('add_to_cart', context),
                                  style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).primaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Image.asset(Images.shopping_cart_bold),
                                ),
                              ],
                            ),
                          ) :
                          Consumer<CartProvider>(builder: (context, cart, child) =>
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (cart.cartList[cardIndex].quantity > 1) {
                                        Provider.of<CartProvider>(context, listen: false).setQuantity(false, cardIndex);
                                      } else {
                                        Provider.of<CartProvider>(context, listen: false).removeFromCart(cardIndex, context);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.PADDING_SIZE_SMALL,
                                        vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                      ),
                                      child: Icon(Icons.remove, size: 20, color: Theme.of(context).primaryColor,),
                                    ),
                                  ),

                                  Text(
                                    cart.cartList[cardIndex].quantity.toString(), style: poppinsSemiBold.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                    color: Theme.of(context).primaryColor,
                                  ),),

                                  InkWell(
                                    onTap: () {
                                      if (cart.cartList[cardIndex].quantity < cart.cartList[cardIndex].stock) {
                                        Provider.of<CartProvider>(context, listen: false).setQuantity(true, cardIndex);
                                      } else {
                                        showCustomSnackBar(getTranslated('out_of_stock', context), context);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.PADDING_SIZE_SMALL,
                                        vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                                      child: Icon(Icons.add, size: 20, color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                          ),

                        ],),
                      ],
                    ),
                  ),
                ),
              ],),


              Positioned.fill(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: WishButton(product: widget.product, edgeInset: const EdgeInsets.all(8.0),),
                  )
              ),
            ],),

          ),
        );

  }

}


