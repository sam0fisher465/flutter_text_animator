import 'package:flutter_text_animator/text_animator/controllers/ATextController.dart';

import 'package:flutter/material.dart';

enum TextPaintStyle
{
  police,
  randomBrokenLight,
  simpleBrokenLight,
  slide,
  backAndFourth,
}

class TextPaintController extends ATextController
{
  /// The collection of colors to paint a string with
  List<Color> colors;
  /// The start alignment of the generated gradient
  final Alignment gradientBegin;
  /// The end alignment of the generated gradient
  final Alignment gradientEnd;
  /// The desired animation style based on pre-defined TextPaintStyle enum
  final TextPaintStyle style;
  /// Duration of a single string
  final Duration duration;
  
  double _gradientStep;
  List<int> _affectedStops;
  List<double> _gradientStops;

  TextPaintController(
    List<String> textCollection,
    Text sample,
    {
      @required this.duration,
      @required this.colors,
      this.gradientBegin = Alignment.topCenter,
      this.gradientEnd = Alignment.bottomCenter,
      this.style = TextPaintStyle.randomBrokenLight,
      double updateNormalizer = 0.3
    }
  ) : super(textCollection, sample, updateNormalizer: updateNormalizer);
  
  @override
  void initialize()
  {
    super.initialize();

    if (this.colors == null || this.colors.length <= 0)
      throw Exception("TextPaintController Error: colors list is empty");

    this._gradientStops = List<double>(this.colors.length);
    this._affectedStops = List<int>();
    this._gradientStep = 1 / this.colors.length;
  }

  void _reset(AnimationController controller)
  {
    if (controller.duration != this.duration)
      controller.duration = this.duration; // Duration per text

    this._affectedStops.clear();

    this.recalculateUpdateModular(controller.duration);
  }

  @override
  void onControllerUpdate(double controllerValue)
  {
    super.onControllerUpdate(controllerValue);

    switch(this.style)
    {
      case TextPaintStyle.police:

        if (this.updateNow())
          this.colors = this.colors.reversed.toList();

      break;

      case TextPaintStyle.randomBrokenLight:

        if (this.updateNow())
        {
          for(int i = 0, idx; i < this._affectedStops.length; i++)
          {
            idx = this._affectedStops[i]; // get index for colors array

            this._gradientStops[idx] = (this._gradientStops[idx] == (idx * this._gradientStep) + this._gradientStep)? 
            (idx * this._gradientStep): (idx * this._gradientStep) + this._gradientStep;
          }


          this.speedUpNextUpdateBy(1);
        }
      break;

      case TextPaintStyle.simpleBrokenLight:

        if (this.updateNow())
        {
          int idx = (this.colors.length / 2).round();
          
          this._gradientStops[idx] = (this._gradientStops[idx] <= 0.0)? 
          (idx * this._gradientStep) +  this._gradientStep: 0.0;

          this.speedUpNextUpdateBy(1);
        }
        
      break;

      case TextPaintStyle.slide:

        for (int i = 0; i < this._gradientStops.length; i++)
        {
          if (i == 0)
            this._gradientStops[i] += controllerValue * this.updateNormalizer * 1.5 / 1.2 / (this.maxUpdateIterator / 2);
          else
            this._gradientStops[i] += i * controllerValue * this.updateNormalizer * 1.5 / (this.maxUpdateIterator / 2);
        }

      break;

      case TextPaintStyle.backAndFourth:
        
        for (int i = 0; i < this._gradientStops.length; i++)
        {
            this._gradientStops[i] = (i + 2) * controllerValue * this.updateNormalizer * 2.5 / this.colors.length;
        }

      break;

      default: break;
    }
  }

  @override
  void onControllerDismissed(AnimationController controller)
  {
    super.onControllerDismissed(controller);

    this._reset(controller);
    
    switch(this.style)
    {
      case TextPaintStyle.police:
        for (int i = 0; i < this._gradientStops.length; i++)
        {
          this._gradientStops[i] = (i * this._gradientStep) + this._gradientStep;
        }

      break;

      case TextPaintStyle.randomBrokenLight:

        for (int i = 0; i < this._gradientStops.length; i++)
        {
          if (this.randBool())
            this._affectedStops.add(i);

          this._gradientStops[i] = (i * this._gradientStep) + this._gradientStep;
        }

        if (this._affectedStops.length <= 0)
          this._affectedStops.add(this.randRange(0, this.colors.length));

      break;

      case TextPaintStyle.simpleBrokenLight:

        for (int i = 0; i < this._gradientStops.length; i++)
        {
          this._gradientStops[i] = (i * this._gradientStep) + this._gradientStep;
        }

      break;


      case TextPaintStyle.backAndFourth:
      case TextPaintStyle.slide:

        for (int i = 0; i < this._gradientStops.length; i++)
        {
          this._gradientStops[i] = 0.0;
        }
        
        //this._gradientStops[this._gradientStops.length - 1] = 1;


      break;

      default: break;
    }
  }

  @override
  Widget build() 
  {
    return
    ShaderMask(
      shaderCallback: (Rect bounds)
      {
        final grad = LinearGradient(
          begin: this.gradientBegin,
          end: this.gradientEnd,
          stops: this._gradientStops, // set each color end on the canvas, from 0 to 1 => double
          colors: this.colors,
          //tileMode: TileMode.repeated
        );

        // using bounds directly doesn't work because the shader origin is translated already
        // so create a new rect with the same size at origin
        return grad.createShader(Offset.zero & bounds.size);
      },
      child: this.sample
    );
  }
}