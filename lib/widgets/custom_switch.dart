import 'package:flutter/material.dart';
import 'package:msa/common/styles.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
    begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
    end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
    .animate(CurvedAnimation(parent: _animationController!, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
            ? widget.onChanged(true)
            : widget.onChanged(false);
          },
          child: Container(
            width: 56.0,
            height: 26.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              color: primaryColor
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 0.5, bottom: 0.5, right: 3, left: 3),
              child: Container(
                alignment : widget.value 
                ? Alignment.centerRight 
                : Alignment.centerLeft,
                child : _circleAnimation!.value == Alignment.centerLeft 
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("オン", style: switchTextStyle),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Material(
                        elevation: 5,
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text("オフ", style: switchTextStyle),
                    ),
                  ],
                )
              ),
            ),
          ),
        );
      },
    );
  }
}