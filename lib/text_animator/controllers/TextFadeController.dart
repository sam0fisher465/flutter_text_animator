import 'package:flutter_text_animator/text_animator/controllers/ATextController.dart';
import 'package:flutter/material.dart';

class TextFadeController extends ATextController
{
  /// Duration of a single string
  final Duration duration;

  TextFadeController(
    List<String> textCollection,
    Text sample,
    {
      @required this.duration,
    }
  ) : super(textCollection, sample);

  void _reset(AnimationController controller)
  {
    if (this.duration != controller.duration)
      controller.duration = this.duration;
  }

  @override
  Widget build()
  {
    return this.sample;
  }

  @override
  void onControllerDismissed(AnimationController controller)
  {
    super.onControllerDismissed(controller);

    this._reset(controller);
  }
}