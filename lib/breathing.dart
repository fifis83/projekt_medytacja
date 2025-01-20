import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:projekt_medytacja/app_bar_content.dart';
import 'package:projekt_medytacja/retention.dart';
import 'package:projekt_medytacja/data_utils.dart';

class Breathing extends StatefulWidget {
  const Breathing({super.key, required this.round});

  final int round;

  @override
  State<Breathing> createState() => _BreathingState();
}

class _BreathingState extends State<Breathing>
    with SingleTickerProviderStateMixin {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  int? _breathsBeforeRetention = 30;
  bool? _breathingMusic = false;
  bool? _retentionMusic = false;
  bool? _voice = false;
  bool? _pingAndGong = false;
  int? _speed = 1;

  int _curBreaths = 0;

  late AnimationController _animationController;
  late Animation<double> scaleAnimation;

  void getUserPreferences() async {
    if (await prefs.getInt('bBR') != null) {
      _breathsBeforeRetention = await prefs.getInt('bBR');
      _speed = await prefs.getInt('s');
      _breathingMusic = await prefs.getBool('bM');
      _retentionMusic = await prefs.getBool('rM');
      _voice = await prefs.getBool('v');
      _pingAndGong = await prefs.getBool('pAG');
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1300),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_breathsBeforeRetention != _curBreaths) {
          setState(() {
            _curBreaths++;
          });
          _animationController.reverse();
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Retention(round: widget.round),
            ),
          );
        }
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    scaleAnimation = Tween<double>(begin: 1, end: 0.01).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuart,
      ),
    );

    setState(() {
      getUserPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: appBarContent(widget.round, context),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Retention(round: widget.round),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("Take $_breathsBeforeRetention deep breaths"),

            //TODO think about this
            Expanded(
              child: ScaleTransition(
                scale: scaleAnimation,
                alignment: Alignment.center,
                child: HexagonWidget.pointy(
                  width: 200,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    alignment: Alignment.center,
                    child: HexagonWidget.pointy(
                      width: 190,
                      color: Theme.of(context).colorScheme.primary,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        alignment: Alignment.center,
                        child: HexagonWidget.pointy(
                          width: 180,
                          color: Theme.of(context).colorScheme.primaryFixedDim,
                          child: ScaleTransition(
                            scale: scaleAnimation,
                            alignment: Alignment.center,
                            child: HexagonWidget.pointy(
                              width: 170,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                              child: Text(
                                _curBreaths.toString(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text("Tap twice to go into retention"),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

