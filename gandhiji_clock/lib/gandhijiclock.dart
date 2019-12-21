// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flare_flutter/flare_actor.dart';

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0x88ffffbd),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Color(0x88ffffbd),
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A basic digital clock.
///
/// You can do better than this!
class GandhiClock extends StatefulWidget {
  const GandhiClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<GandhiClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(GandhiClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final day = _dateTime.day;
    final month = _dateTime.month;
    final year = _dateTime.year;
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final dWidth = MediaQuery.of(context).size.width;
    final dHeight = MediaQuery.of(context).size.height;
    final offset = -fontSize / 7;
    bool hasexploded = false;
    // final defaultStyle = TextStyle(
    //   color: colors[_Element.text],
    //   fontFamily: 'PressStart2P',
    //   fontSize: fontSize,
    //   shadows: [
    //     Shadow(
    //       blurRadius: 0,
    //       color: colors[_Element.shadow],
    //       offset: Offset(10, 0),
    //     ),
    //   ],
    // );

    return Container(
      color: colors[_Element.background],
      child: 
      Stack(
        children: <Widget>[
          // GestureDetector(
          //   onTap: () {
          //     // print("asdf");
          //     // if(hasexploded)
          //   },
          // child:
          // Rect.fromCenter(center: Offset(0,0),width: 500,height: 500),
          Positioned.fill(
            left: dWidth/15,
            top: dHeight/9,
              child: FlareActor(
                "assets/charkho.flr",
                animation: "snip",
                fit: BoxFit.cover,
                // color: Colors.black,
              ),
          ),
          // ),
          // Positioned()
          // ),
          Positioned.fill(
            left: dWidth/2.3,
            top: dHeight/15,
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      hour,
                      style: TextStyle(
                          fontSize: dWidth/10,
                          color: Color(0xFF992505),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ":",
                      style: TextStyle(
                          fontSize: dWidth/10,
                          color: Color(0xFF992505),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      minute,
                      style: TextStyle(
                          fontSize: dWidth/10,
                          color: Color(0xFF992505),
                          fontWeight: FontWeight.bold),
                    ),

                    Text(
                      "",
                      style: TextStyle(
                          fontSize: 60,
                          color: Color(0xFF992505),
                          fontWeight: FontWeight.bold),
                    ),
                    // Text(":"),
                    // Text(minute),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            left: dWidth/2.3,
            top: dHeight/15+dWidth/10,
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      day.toString(),
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF992505),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "/",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF992505),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      month.toString(),
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF992505),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "/",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF992505),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      year.toString(),
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF992505),
                          fontWeight: FontWeight.bold),
                    ),
                    // Text(":"),
                    // Text(minute),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
