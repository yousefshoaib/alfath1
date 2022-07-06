import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/rating_bar.dart';
import 'package:flutter_grocery/view/base/wish_button.dart';
import 'package:flutter_grocery/view/screens/product/widget/variation_view.dart';
import 'package:provider/provider.dart';

class ProductTitleView extends StatefulWidget {

  final Product product;
  final int stock;
  final int cartIndex;

  ProductTitleView({@required this.product, @required this.stock,@required this.cartIndex,});

  @override
  State<ProductTitleView> createState() => _ProductTitleViewState();

}

class _ProductTitleViewState extends State<ProductTitleView> {
  double changeString(String string){
    double string1 =double.parse(string);
    return string1;
  }

  //VariationView VariationViewState ;

  var variationViewState =new VariationViewState();
  String dropdownValue = 'Piece';
  double  box = 1;

  @override
  Widget build(BuildContext context) {
    print('==========${widget.cartIndex}');

    double _startingPrice;
    double _endingPrice;
    if(widget.product.variations.length != 0) {
      List<double> _priceList = [];
      widget.product.variations.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if(_priceList[0] < _priceList[_priceList.length-1]) {
        _endingPrice = _priceList[_priceList.length-1];
      }
    }else {
      _startingPrice = widget.product.price;
    }
   // if(widget.product.variations.isNotEmpty)
    //var discountBox = double.parse(widget.product.variations.single.type);
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(Dimensions.PADDING_SIZE_DEFAULT), topRight: Radius.circular(Dimensions.PADDING_SIZE_DEFAULT)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.product.name ?? '',
                      style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getTextColor(context)),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  WishButton(product: widget.product),

                ],
              ),
            ),

            widget.product.rating != null ? Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: RatingBar(
                rating: widget.product.rating.length > 0 ? double.parse(widget.product.rating[0].average) : 0.0, size: Dimensions.PADDING_SIZE_DEFAULT,
              ),
            ) : SizedBox(),

            //Product Price
            Text(
              box==1||widget.product.variations.isEmpty ? '${PriceConverter.convertPrice(
                  context, widget.product.price, discount: widget.product.discount, discountType: widget.product.discountType)}': '${PriceConverter.convertPrice(
                  context, widget.product.variations.single.price, discount:changeString(widget.product.variations.single.type), discountType: widget.product.discountType)}',

              style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
            ),


            Row(

              children: [
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
                '${PriceConverter.convertPrice( context,widget.product.variations.single.price,
                    discount:((widget.product.variations.single.price)-(changeString(widget.product.variations.single.type)))
                    , discountType: widget.product.discountType )}',*/
                  style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                ) : SizedBox(),
              /*Text('ربحية' ,style: poppinsBold.copyWith(fontSize:14 /*Dimensions.FONT_SIZE_SMALL*/, color:Theme.of(context).primaryColor), ),
              /*widget.product.discountType=='amount'?Text(box==1||widget.product.variations.isEmpty?'${widget.product.discount} جنيه مصري ':
              '${discountBox} جنيه مصري ',
                  style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)):*/
              widget.product.discount > 0 ? Text( box==1||widget.product.variations.isEmpty?
              '${PriceConverter.convertPrice(context,widget.product.price ,
                  discount: widget.product.discount, discountType: 'profitability' )}':
              '${PriceConverter.convertPrice(context,widget.product.variations.single.price ,
                  discount: discountBox, discountType: 'profitability')}',
                style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
              ) : SizedBox(),*/


              // product.discount > 0 ? SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL) : SizedBox(),



            ],),
           /* product.discount > 0 ? Text(
              PriceConverter.convertPrice(context, product.price),
              style: poppinsBold.copyWith(color: ColorResources.getHintColor(context),
                  fontSize: Dimensions.FONT_SIZE_SMALL, decoration: TextDecoration.lineThrough),
            ): SizedBox(),*/

            Row(children: [

              /*Text(
                '${widget.product.capacity}  ${widget.product.unit}',
                style: poppinsRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.FONT_SIZE_SMALL),
              ),*/
              Expanded(child: SizedBox.shrink()),
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


              //Expanded(child: SizedBox.shrink()),

              Builder(
                builder: (context) {
                  return Row(children: [
                    QuantityButton(isIncrement: false, quantity: productProvider.quantity, stock: widget.stock,cartIndex: widget.cartIndex),
                    SizedBox(width: 15),
                    Consumer<CartProvider>(builder: (context, cart, child) {
                      return Text(widget.cartIndex != null ? cart.cartList[widget.cartIndex].quantity.toString()
                          : productProvider.quantity.toString(), style: poppinsSemiBold);
                    }),
                    SizedBox(width: 15),
                    QuantityButton(isIncrement: true, quantity: productProvider.quantity, stock: widget.stock, cartIndex: widget.cartIndex),
                  ]
                  );
                }
              ),
            ]),
          ]);
        },
      ),

    );
  }

}

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final int quantity ;
  final bool isCartWidget;
  final int stock;
  final int cartIndex;

  QuantityButton({
    @required this.isIncrement,
    @required this.quantity,
    @required this.stock,
    this.isCartWidget = false,
    @required this.cartIndex,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(cartIndex != null) {
          if(isIncrement) {
            if (Provider.of<CartProvider>(context, listen: false).cartList[cartIndex].quantity < Provider.of<CartProvider>(context, listen: false).cartList[cartIndex].stock) {
              Provider.of<CartProvider>(context, listen: false).setQuantity(true, cartIndex, showMessage: true, context: context);
            } else {
              showCustomSnackBar(getTranslated('out_of_stock', context), context);
            }
          }else {
            if (Provider.of<CartProvider>(context, listen: false).cartList[cartIndex].quantity > 1) {
              Provider.of<CartProvider>(context, listen: false).setQuantity(false, cartIndex, showMessage: true, context: context);
            } else {
             // Provider.of<ProductProvider>(context, listen: false).setExistData(null);
              Provider.of<CartProvider>(context, listen: false).removeFromCart(cartIndex, context);
            }
          }
        }else {
          if (!isIncrement && quantity > 1) {
            Provider.of<ProductProvider>(context, listen: false).setQuantity(false);
          } else if (isIncrement) {
            if(quantity < stock) {
              Provider.of<ProductProvider>(context, listen: false).setQuantity(true);
            }else {
              showCustomSnackBar(getTranslated('out_of_stock', context), context);
            }
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color:  ColorResources.getGreyColor(context))),
        child: Icon(
          isIncrement ? Icons.add : Icons.remove,
          color: isIncrement
              ?  Theme.of(context).primaryColor
              : quantity > 1
                  ?  Theme.of(context).primaryColor
                  :  Theme.of(context).hintColor,
          size: isCartWidget ? 26 : 20,
        ),
      ),
    );
  }
}

