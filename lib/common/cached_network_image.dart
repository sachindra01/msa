// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CachedNetworkimage extends StatefulWidget {
  const CachedNetworkimage(
      {Key? key,
      required this.imageUrl,
       this.width,
       this.height})
      : super(key: key);
  final String imageUrl;
  final double? width;
  final double? height;

  @override
  _CachedNetworkimageState createState() => _CachedNetworkimageState();
}

class _CachedNetworkimageState extends State<CachedNetworkimage> {
  @override
  Widget build(BuildContext context) {
    return widget.imageUrl != ''
    ? CachedNetworkImage(
        fit: BoxFit.cover,
        width: widget.width,
        height: widget.height,
        placeholder: (context, url) => const CustomShimmer(),
        imageUrl: widget.imageUrl,
        errorWidget: (context, url,_)=>Image.asset(
          'assets/images/no_image_new.png',
          width: widget.width,
          height: widget.height,
          fit: BoxFit.cover,
        ),
      )
    : Image.asset(
      'assets/images/no_image_new.png',
      width: widget.width,
      height: widget.height,
      fit: BoxFit.cover,
    );
  }
}


class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    Key? key,
    this.height = 100,
    this.width = 100,
    this.isCircular = false,
    this.radius,
  }) : super(key: key);
  final double? height;
  final double? width;
  final bool? isCircular;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: 
           Colors.grey[300]!,
      highlightColor:
          Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius ?? 8),
        ),
      ),
    );
  }
}
