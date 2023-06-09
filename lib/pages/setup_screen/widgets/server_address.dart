import 'package:flutter/material.dart';

class ServerAddress extends StatefulWidget {
  final bool fadeServerAddress;
  final TextEditingController serverAddressController;
  const ServerAddress(
      {super.key,
      required this.serverAddressController,
      required this.fadeServerAddress});

  @override
  State<ServerAddress> createState() => _ServerAddressState();
}

class _ServerAddressState extends State<ServerAddress>
    with SingleTickerProviderStateMixin {
  double bottomAnimationValue = 0;
  double opacityAnimationValue = 0;
  EdgeInsets paddingAnimationValue = EdgeInsets.only(top: 22);

  late TextEditingController serverAddressController;
  late AnimationController _animationController;
  late Animation<Color?> _animation;

  FocusNode node = FocusNode();
  @override
  void initState() {
    serverAddressController = widget.serverAddressController;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    final tween =
        ColorTween(begin: Colors.grey.withOpacity(0), end: Colors.blue[700]);

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
          tween: Tween(begin: 0, end: widget.fadeServerAddress ? 0 : 1),
          builder: ((_, value, __) => Opacity(
                opacity: value,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: serverAddressController,
                  textInputAction: TextInputAction.next,
                  focusNode: node,
                  decoration:
                      InputDecoration(hintText: "Server Address of MiriHome"),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) async {
                    if (value.isNotEmpty) {
                      if (isValidServerAddress(value)) {
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
                  validator: (serverAddress) => serverAddress != null &&
                          !isValidServerAddress(serverAddress)
                      ? "Enter a valid server address"
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
              tween: Tween(begin: 0, end: widget.fadeServerAddress ? 0 : 1),
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

  bool isValidServerAddress(String serverAddress) {
    return RegExp(r"\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b")
        .hasMatch(serverAddress);
  }
}
