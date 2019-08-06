import 'dart:math';

import 'package:flutter/material.dart';

abstract class ATextController
{
  /// The string collection to be animated
  final List<String> textCollection;
  Text sample;

  
  double updateNormalizer; // Normalized 0.0 to 1.0

  int _currentTextIdx;
  Random _rand;
  int _updateCounter;
  int _updateModuler; // If this number is reached within animationbuilder frames then update occurs
  int maxUpdateIterator;

  ATextController(
    this.textCollection, 
    this.sample,
    {
      this.updateNormalizer = 1,
  });

  void initialize()
  {
    this.updateNormalizer = this.updateNormalizer.clamp(0.000, 1.000);
    this._currentTextIdx = -1;
    this._updateCounter = 0;
    this._rand = Random();
  }

  void recalculateUpdateModular(Duration duration)
  {
    this.maxUpdateIterator = (duration.inMicroseconds / 1000000 * 60).floor();
    this._updateModuler = (this.maxUpdateIterator * this.updateNormalizer).floor();
  }

  void onControllerDismissed(AnimationController controller)
  {
    this._updateCounter = 0;
    this._currentTextIdx++;

    if (this._currentTextIdx >= this.textCollection.length)
      this._currentTextIdx = 0;

    this.sample = this.createTextWidget(this.textCollection[this._currentTextIdx]);
  }

  // Use it just to update
  void onControllerUpdate(double controllerValue)
  {
    this._updateCounter++;
  }

  void onControllerCompleted()
  {
  }

  Widget build();

  Text createTextWidget(String text)
  {
    return 
    Text(
      text,
      key: this.sample.key,
      locale: this.sample.locale,
      maxLines: this.sample.maxLines,
      overflow: this.sample.overflow,
      semanticsLabel: this.sample.semanticsLabel,
      softWrap: this.sample.softWrap,
      strutStyle: this.sample.strutStyle,
      style: this.sample.style,
      textAlign: this.sample.textAlign,
      textDirection: this.sample.textDirection,
      textScaleFactor: this.sample.textScaleFactor,
      textWidthBasis: this.sample.textWidthBasis,
    );
  }

  // helpers
  // Lower numbers for slower next update
  void speedUpNextUpdateBy(int value) => this._updateCounter += this.randRange(0, (this._updateModuler - 1 / value).toInt());
  bool updateNow() => (this._updateCounter % this._updateModuler == 0);
  bool playedAll() => (this._currentTextIdx + 1 >= this.textCollection.length);
  int getCurrentTextIndex() => this._currentTextIdx;

  int randRange(int min, int max) => min + this._rand.nextInt(max - min);
  bool randBool() => this._rand.nextBool();
  double randDouble() => this._rand.nextDouble();
}