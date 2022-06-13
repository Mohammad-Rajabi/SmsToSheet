import 'package:flutter/material.dart';

class FailureOrNoInternetOrEmptyWidget extends StatelessWidget {
  VoidCallback? _voidCallback;
  String? _title;
  String buttonText;
  Widget? _child;

  FailureOrNoInternetOrEmptyWidget(
      {Key? key,
      VoidCallback? voidCallback,
      Widget? child,
      String? title,
      required this.buttonText})
      : _child = child,
        _title = title,
        _voidCallback = voidCallback,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _child ?? const SizedBox(),
          const SizedBox(
            height: 8,
          ),
          _title != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    _title!,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                )
              : const SizedBox(),
          _voidCallback != null
              ? TextButton(
                  onPressed: _voidCallback,
                  child: Text(
                    buttonText,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
