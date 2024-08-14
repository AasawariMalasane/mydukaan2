import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mydukaanapp2/config/app_config.dart';
import 'package:mydukaanapp2/utils/helpers.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../models/homepage_model.dart';
import '../utils/app_colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isInCart;
  final bool isInWishlist;
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromCart;
  final VoidCallback onAddToWishlist;
  final VoidCallback onRemoveFromWishlist;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.isInCart,
    required this.isInWishlist,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onAddToWishlist,
    required this.onRemoveFromWishlist,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 150,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  color: AppColors.lightTextColor,
                  offset: Offset(0, 0),
                  blurRadius: 8,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: '${AppConfig.baseUrl}${product.displayImage}',
                  imageBuilder: (context, imageProvider) => Container(
                    height: 90.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Container(height: 90, width: 150),
                  errorWidget: (context, url, error) => Container(
                    height: 90.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                      image: DecorationImage(image: AssetImage("assets/images/NoImage.jpg"), fit: BoxFit.cover),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: textTheme.titleLarge),
                        Row(
                          children: [
                            Text( "₹ ${product.variant[0].sellingPrice}", style: textTheme.titleSmall),
                            SizedBox(width: 10,),
                            if (product.variant[0].listingPrice != 0)
                              Text("₹ ${product.variant[0].listingPrice}", style:GoogleFonts.inter(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.lightgrey,
                                fontWeight: FontWeight.w500,
                                height: 1.19, // line height 23.87px divided by font size 20px
                                letterSpacing: 1,),
                              )
                          ],
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SmoothStarRating(
                              allowHalfRating: true,
                              starCount: 5,
                              rating: product.averageRating.toDouble(),
                              size: 15.0,
                              color: Color(0xffFEC736),
                              borderColor: Color(0xffFEC736),
                              spacing: 0.0,
                            ),
                            GestureDetector(
                              onTap:isInCart?onRemoveFromCart:onAddToCart,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    child: Icon(
                                      isInCart? Icons.shopping_cart:
                                      Icons.shopping_cart_outlined,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: GestureDetector(
              onTap: isInWishlist ? onRemoveFromWishlist : onAddToWishlist,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                ),
              ),
            ),
          ),
          if (product.discount > 0)
            Positioned(
              left: 12,
              top: 8,
              width: 20,
              height:35,
              child: Stack(
                children: [
                  Image(
                    image: AssetImage('assets/images/badge.png'),
                    fit: BoxFit.fill,
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(bottom: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${product.discount}% off",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}