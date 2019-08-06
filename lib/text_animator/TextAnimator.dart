import 'package:flutter/material.dart';
import 'package:flutter_text_animator/text_animator/controllers/ATextController.dart';
import 'package:flutter_text_animator/text_animator/wrappers/ATextWrapper.dart';

class TextAnimator extends StatefulWidget
{
  /// A container for a string to be rendered within (i.e. TextBaseWrapper())
  final TextBaseWrapper wrapper;
  /// A controller to animate the string collection (i.e. TextFadeController())
  final ATextController controller;
  /// wheather to loop the given string collection or not
  final bool loop;
  /// A method to be called before the start of a string (i.e. if a collage of photos 
  /// were to be displayed with a certain word)
  final Function(int) onAWordStart;
  /// A method to be called upon animating all given strings 
  final Function onAllWordsEnd;

  TextAnimator({
    Key key,
    @required this.wrapper,
    @required this.controller,
    this.loop = true,
    this.onAWordStart,
    this.onAllWordsEnd
  })
  : super(key: key);

  @override
  _TextAnimatorState createState() => _TextAnimatorState();
}

class _TextAnimatorState extends State<TextAnimator> with SingleTickerProviderStateMixin
{
  AnimationController _controller;

  @override
  void initState()
  {
    this._controller = AnimationController(vsync: this); // Duration per text
    this._controller.addStatusListener((status) { this._onStatusChanged(status); });
    this.widget.controller.initialize();

    this._onStatusChanged(AnimationStatus.dismissed); // To start the loop
    super.initState();
  }

  @override
  void dispose()
  {
    this._controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TextAnimator oldWidget)
  {
    this.widget.controller.initialize();

    this._onStatusChanged(AnimationStatus.dismissed);

    super.didUpdateWidget(oldWidget);
  }

  // Make sure it's added to animation listeners only ONCE, otherwise remove trace
  void _onStatusChanged(AnimationStatus status)
  {
    switch(status)
    {
      case AnimationStatus.completed:
        this.widget.controller.onControllerCompleted();

        this._controller.reverse();
        
      break;

      case AnimationStatus.dismissed:

        if (this.widget.controller.playedAll())
        {
          if (this.widget.onAllWordsEnd != null)
            this.widget.onAllWordsEnd();

          if (!this.widget.loop)
            return;
        }

        this.widget.controller.onControllerDismissed(this._controller);
        this.widget.wrapper.reset(this._controller);

        if (this.widget.onAWordStart != null)
          this.widget.onAWordStart(this.widget.controller.getCurrentTextIndex());

        this._controller.forward();
        
      break;

      default: break;
    }
  }

  Widget build(BuildContext context)
  {
    print("Built TextAnimator");

    return this.getAnimatedBuilder();
  }

  Widget getAnimatedBuilder() =>
  AnimatedBuilder(
    animation: this._controller,
    builder: (BuildContext context, Widget child) 
    {
      if (this._controller.value != null)
        this.widget.controller.onControllerUpdate(this._controller.value);

      return this.widget.wrapper.build(this.widget.controller.build());
    },
  );
}

