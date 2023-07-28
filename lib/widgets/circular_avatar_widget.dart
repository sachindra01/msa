import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:msa/common/cached_network_image.dart';
import 'package:msa/common/styles.dart';

class CircularAvatarWidget extends StatefulWidget {
  const CircularAvatarWidget(
      {Key? key,
      required this.imageUrl,
      required this.width,
      required this.height})
      : super(key: key);
  final String imageUrl;
  final double width;
  final double height;

  @override
  _CircularAvatarWidgetState createState() => _CircularAvatarWidgetState();
}

class _CircularAvatarWidgetState extends State<CircularAvatarWidget> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: primaryColor,
      radius: 42,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(500.0),
        child: widget.imageUrl != ''
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
              fit: BoxFit.fill,
            ),
      ),
    );
  }
}
