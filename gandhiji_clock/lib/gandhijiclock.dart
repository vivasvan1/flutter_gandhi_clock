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
}

final _lightTheme = {
  _Element.background: Color(0x99ffffbd),
  _Element.text: Color(0xFF992505),
};

final _darkTheme = {
  _Element.background: Color(0xaaffffbd),
  _Element.text: Color(0xFF992505),
};

/// A basic digital clock.
///
/// You can do better than this!
class GandhiClock extends StatefulWidget {
  const GandhiClock(this.model);
  final ClockModel model;

  @override
  _GandhiClockState createState() => _GandhiClockState();
}

class _GandhiClockState extends State<GandhiClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  double fontSize;
  final _sizeKey = GlobalKey();

//   _getSizes() {
//     final RenderBox renderBoxRed = _sizeKey.currentContext.findRenderObject();
//     final sizeRed = renderBoxRed.size;
  // fontSize = sizeRed.width / 3.5;
//     print("SIZE of Red: $sizeRed");
//  }

//   _afterLayout(_) {
//     _getSizes();
//     // _getPositions();
//   }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
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
    final ampm =
        DateFormat(widget.model.is24HourFormat ? '' : 'a').format(_dateTime);
    final day = _dateTime.day;
    final month = _dateTime.month;
    final year = _dateTime.year;
    final minute = DateFormat('mm').format(_dateTime);
    fontSize = MediaQuery.of(context).size.width / 3;
    final timeSize = fontSize / 2.5;
    final ampmSize = fontSize / 6;
    final dateSize = fontSize / 8;
    final offsetH = fontSize / 3;
    final offsetV = fontSize / 5;
    return Container(
      key: _sizeKey,
      color: colors[_Element.background],
      child: Stack(
        children: <Widget>[
          // OVERLAY TEXTURE IMAGE
          Image(
            image: AssetImage("assets/texture.png"),
            fit: BoxFit.cover,
            color: colors[_Element.background],
          ),
          // CHARKHO FLARE
          Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            alignment: Alignment.bottomCenter,
            child: FlareActor(
              "assets/charkho.flr",
              alignment: Alignment.bottomCenter,
              animation: "snip",
              fit: BoxFit.contain,
            ),
          ),
          // DATE
          Container(
            margin:
                EdgeInsets.symmetric(horizontal: offsetH, vertical: offsetV),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: widget.model.is24HourFormat
                      ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                      : EdgeInsets.fromLTRB(0, 0, ampmSize * 1.1, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        day.toString() +
                            "/" +
                            month.toString() +
                            "/" +
                            year.toString(),
                        style: TextStyle(
                            fontFamily: "BebasNeue-Regular",
                            fontSize: dateSize,
                            color: colors[_Element.text],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, dateSize / 2, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        hour,
                        style: TextStyle(
                            fontFamily: "BebasNeue-Regular",
                            fontSize: timeSize,
                            color: colors[_Element.text],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ":",
                        style: TextStyle(
                            height: 0.8,
                            fontFamily: "BebasNeue-Regular",
                            fontSize: timeSize,
                            color: colors[_Element.text],
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        minute,
                        style: TextStyle(
                            // backgroundColor: Colors.black,
                            fontFamily: "BebasNeue-Regular",
                            fontSize: timeSize,
                            color: colors[_Element.text],
                            fontWeight: FontWeight.bold),
                      ),
                      widget.model.is24HourFormat
                          ? Text("")
                          : Text(
                              " " + ampm,
                              style: TextStyle(
                                  // backgroundColor: Colors.black,
                                  fontFamily: "BebasNeue-Regular",
                                  fontSize: ampmSize,
                                  height: 2.7,
                                  color: colors[_Element.text],
                                  fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
