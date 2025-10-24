import 'package:flutter/cupertino.dart';

class ClampedBox extends StatelessWidget {
  final Widget child;

  const ClampedBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
            maxHeight: constraints.maxHeight,
          ),
          child: child,
        );
      },
    );
  }
}
