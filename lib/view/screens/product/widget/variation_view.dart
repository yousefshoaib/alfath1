import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

import '../../../../helper/responsive_helper.dart';

class VariationView extends StatefulWidget {
  final Product product;
  VariationView({@required this.product});

  @override
  State<VariationView> createState() => VariationViewState();
}

class VariationViewState extends State<VariationView> {
  String dropdownValue = 'Box';
  bool boxOrPiece=true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {

        return  Container(
          padding: EdgeInsetsDirectional.all(10),
          alignment: Alignment.bottomLeft,
          child: DropdownButton<String>(
            onTap: (){
              if(dropdownValue=='Box'){
                boxOrPiece=true;
              }else {
                boxOrPiece=false;
              }
              setState(() {});
            },

            value: dropdownValue,
            /*icon: const Icon(Icons.arrow_downward),*/
            //elevation: 16,
            style: const TextStyle(color: Color(0xFF01684B)),
            underline: Container(
              height: 2,
              color:Theme.of(context).primaryColor,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items:<String>['Box' , 'Piece']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );

        /* ListView.builder(
          shrinkWrap: true,
          itemCount: product.choiceOptions.length,
          padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL) : EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          physics:  NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.choiceOptions[index].title, style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                  childAspectRatio: (1 / 0.25),
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: product.choiceOptions[index].options.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      productProvider.setCartVariationIndex(index, i);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      decoration: BoxDecoration(
                        color: productProvider.variationIndex[index] != i ? ColorResources.getBackgroundColor(context) : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5),
                        border: productProvider.variationIndex[index] != i ? Border.all(color: ColorResources.getGreyColor(context), width: 2) : null,
                      ),
                      child: Text(
                        product.choiceOptions[index].options[i].trim(), maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: poppinsRegular.copyWith(
                          color: productProvider.variationIndex[index] != i ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: index != product.choiceOptions.length-1 ? Dimensions.PADDING_SIZE_LARGE : 0),
            ]);
          },
        );*/
    //  },
   // );
  }
}
