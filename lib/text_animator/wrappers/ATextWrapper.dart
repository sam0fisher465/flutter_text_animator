import 'package:flutter/material.dart';

class TextBaseWrapper
{
  final Alignment alignment;
  final bool useFittedBox;

  TextBaseWrapper({
    this.alignment = Alignment.center,
    this.useFittedBox = true
    }
  );

  void reset(AnimationController controller)
  {

  }

  Widget build(Widget child)
  {
    return 
    Align(
      alignment: this.alignment,
      child: (this.useFittedBox)?
      FittedBox(
        fit: BoxFit.contain,
        child: child,
      ):
      child,
    );
  }

}