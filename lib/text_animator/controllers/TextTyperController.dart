import 'package:flutter_text_animator/text_animator/controllers/ATextController.dart';

import 'package:flutter/material.dart';


enum TextTyperStyle
{
  consistent,
  consistentWithDelete,
}

class TextTyperController extends ATextController
{
  final Duration duration;
  final String symbol;
  final TextTyperStyle style;
  String _fullString;
  int _subStringIdx;
  bool _reverse;

  TextTyperController(
    List<String> textCollection,
    Text sample,
    {
      @required this.duration,
      this.symbol = "_",
      this.style = TextTyperStyle.consistent
    }
  ) : super(textCollection, sample);

  void _reset(AnimationController controller)
  {
    controller.duration = Duration(microseconds: this.duration.inMicroseconds * this.sample.data.length);
    this.updateNormalizer = 1 / (this.sample.data.length * 1.1);

    this.recalculateUpdateModular(controller.duration);
  }

  @override
  void onControllerUpdate(double controllerValue)
  {
    super.onControllerUpdate(controllerValue);

    if (this.updateNow())
    {
      switch(this.style)
      {
        case TextTyperStyle.consistent:
          if (this._subStringIdx + 1 <= this._fullString.length)
            this._subStringIdx++;
        break;

        case TextTyperStyle.consistentWithDelete:
          if (this._reverse)
          {
            if (this._subStringIdx > 0)
              this._subStringIdx--;
          }
          else
          {
            if (this._subStringIdx + 1 <= this._fullString.length)
              this._subStringIdx++;
          }
        break;
      }

      this.sample = this.createTextWidget(this._fullString.substring(0, this._subStringIdx) + this.symbol);
    }

  }

  @override
  void onControllerDismissed(AnimationController controller)
  {
    super.onControllerDismissed(controller);

    this._reset(controller);

    this._fullString = this.sample.data;
    this._reverse = false;
    this._subStringIdx = 0;
    this.sample = this.createTextWidget(this._fullString.substring(0, this._subStringIdx) + this.symbol);
  }

  @override
  void onControllerCompleted()
  {
    //await Future.delayed(Duration(seconds: 3));

    this._reverse = true;
  }

  @override
  Widget build()
  {
    return this.sample;
  }

}