import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NameField extends StatefulWidget {
  final bool fadeFirstName;
  final TextEditingController firstNameController;
  const NameField(
      {super.key,
      required this.firstNameController,
      required this.fadeFirstName});

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField>
    with SingleTickerProviderStateMixin {
  double bottomAnimationValue = 0;
  double opacityAnimationValue = 0;
  EdgeInsets paddingAnimationValue = EdgeInsets.only(top: 22);
  static const String firstNameRegularExpression =
      r"^(?=.{3,40}$)[a-zA-Z]+(?:[-'\s][a-zA-Z]+)*";

  late TextEditingController firstNameController;
  late AnimationController _animationController;
  late Animation<Color?> _animation;

  FocusNode node = FocusNode();
  @override
  void initState() {
    firstNameController = widget.firstNameController;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    final tween =
        ColorTween(begin: Colors.grey.withOpacity(0), end: Color(0xff21579C));

    _animation = tween.animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();

    node.addListener(() {
      if (node.hasFocus) {
        setState(() {
          bottomAnimationValue = 1;
        });
      } else {
        setState(() {
          bottomAnimationValue = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300),
          tween: Tween(begin: 0, end: widget.fadeFirstName ? 0 : 1),
          builder: ((_, value, __) => Opacity(
                opacity: value,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: firstNameController,
                  textInputAction: TextInputAction.next,
                  focusNode: node,
                  decoration: InputDecoration(hintText: "First Name"),
                  keyboardType: TextInputType.name,
                  onChanged: (value) async {
                    if (value.isNotEmpty) {
                      if (isValidName(value)) {
                        setState(() {
                          bottomAnimationValue = 0;
                          opacityAnimationValue = 1;
                          paddingAnimationValue = EdgeInsets.only(top: 0);
                        });
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                        setState(() {
                          bottomAnimationValue = 1;
                          opacityAnimationValue = 0;
                          paddingAnimationValue = EdgeInsets.only(top: 22);
                        });
                      }
                    } else {
                      setState(() {
                        bottomAnimationValue = 0;
                      });
                    }
                  },
                  validator: (firstName) =>
                      firstName != null && !isValidName(firstName)
                          ? "Enter a valid Name"
                          : null,
                ),
              )),
        ),
        Positioned.fill(
          child: AnimatedPadding(
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 500),
            padding: paddingAnimationValue,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: widget.fadeFirstName ? 0 : 1),
              duration: Duration(milliseconds: 700),
              builder: ((context, value, child) => Opacity(
                    opacity: value,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0)
                            .copyWith(bottom: 0),
                        child: Icon(Icons.check_rounded,
                            size: 27,
                            color: _animation.value // _animation.value,
                            ),
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  bool isValidName(String firstName) {
    return RegExp(firstNameRegularExpression).hasMatch(firstName);
  }
}
