import 'package:flutter_text_animator/text_animator/wrappers/ATextWrapper.dart';
import 'package:flutter/material.dart';

class TextOpacityWrapper extends TextBaseWrapper
{
  /// The begining of the opacity fade (0 to 1)
  double beginFade;
  /// The end of the opacity fade (0 to 1)
  double endFade;
  /// The curve of the opacity fading in (i.e. Curves.linear)
  final Curve fadeIn;
  /// The curve of the opacity fading out (i.e. Curves.decelerate)
  final Curve fadeOut;
  Animation<double> _fadeAnimation;

  TextOpacityWrapper({
    Alignment alignment = Alignment.center,
    bool useFittedBox = true,
    this.beginFade = 0.0,
    this.endFade = 1.0,
    this.fadeIn = Curves.linear,
    this.fadeOut = Curves.linear,
  }) : super(alignment: alignment, useFittedBox: useFittedBox)
  {
    this.beginFade = this.beginFade.clamp(0.0, 1.0);
    this.endFade = this.endFade.clamp(0.0, 1.0);
  }

  @override
  void reset(AnimationController controller)
  {
    this._fadeAnimation = Tween<double>(begin: this.beginFade, end: this.endFade)
    .animate(CurvedAnimation(parent: controller, curve: this.fadeIn, reverseCurve: this.fadeOut));
  }

  @override
  Widget build(Widget child)
  {
    return super.build(
    Opacity(
      opacity: this._fadeAnimation.value.clamp(0.0, 1.0),
      child: child,
    ));
  }
}