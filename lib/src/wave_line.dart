/*
 * Created by yeongguo on 10/09/21 20:33 PM
 * Copyright (c) 2018 Tencent
 *
 * Description:
 */

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const auxiliaryColor = const Color(0x7fA893EF);
const mainColor = const Color(0xceA893EF);

class WaveLine {
  int duration = 200;

  Timer? timer;
  double waveA;
  double waveC;
  double waveD;
  double width;
  double height;
  num tick = 0;
  double x = 0.0;
  Canvas canvas;

  WaveLine({
    required this.canvas,
    required this.width,
    required this.height,
    required this.waveA,
    required this.waveC,
    required this.waveD,
    required this.tick,
  });

  setCanvas(Canvas canvas) {
    this.canvas = canvas;
  }

  fooA1(x, v, t) {
    return (sin(0.8 * x - 3 * pi / 2) * sin(t + 1) * v + v + 0.1);
  }

  fooC1(x, v) {
    return ((20000 * v) / (10000 + pow(x * v, 6)));
  }

  fooD1(x, v, t) {
    return 0.5 * (sin(0.5 * x - pi / 2) - 1) * pow(sin(t - 4), 2) + 1;
  }

  fooC(x) {
    return 4000 / (4000 + pow(0.5 * x, 6));
  }

  fooA2(x, v, t) {
    return (sin(x - pi / 2) * sin(t) * v + v + 0.1);
  }

  fooC2(x, v) {
    return ((8000 * v) / (5000 + pow(x * v, 6)));
  }

  fooD2(x, v, t) {
    return 0.5 * (sin(0.5 * x - pi / 2) - 1) * pow(sin(t - pi / 2), 2) + 1;
  }

  fooE(x) {
    return 4000 / (4000 + pow(0.5 * x, 6));
  }

  updateWave1() {
    Paint p = new Paint();
    Path path = new Path();
    p.color = auxiliaryColor;
    p.isAntiAlias = true;
    p.style = PaintingStyle.fill;
    var a = waveA;
    var c = waveC;
    for (var x = 0; x <= width; x += 1) {
      var xx = (24 * x) / width - 12;
      var yy = fooA1(xx, a, c) * fooC1(xx, a) * fooD1(xx, a, c) * fooC(xx);
      var y = yy * height / 10;
      if (x == 0) {
        path.moveTo(x + 0.0, y + height / 2);
      } else {
        path.lineTo(x + 0.0, y + height / 2);
      }
    }

    for (var x = width; x > 0; x -= 1) {
      var xx = (24 * x) / width - 12;
      var yy = -fooA1(xx, a, c) * fooC1(xx, a) * fooD1(xx, a, c) * fooC(xx);
      var y = yy * height / 10;
      path.lineTo(x, y + height / 2);
    }
    path.close();
    canvas.drawPath(path, p);
  }

  updateWave2() {
    Paint p = new Paint();
    Path path = new Path();
    p.color = mainColor;
    p.isAntiAlias = true;
    p.style = PaintingStyle.fill;
    var a = waveA;
    var c = waveC;
    for (var x = 0; x <= width; x += 1) {
      var xx = (24 * x) / width - 12;
      var yy = fooA2(xx, a, c) * fooC2(xx, a) * fooD2(xx, a, c) * fooE(xx);
      var y = yy * height / 10;
      if (x == 0) {
        path.moveTo(x + 0.0, y + height / 2);
      } else {
        path.lineTo(x + 0.0, y + height / 2);
      }
    }

    for (var x = width; x > 0; x -= 1) {
      var xx = (24 * x) / width - 12;
      var yy = -fooA2(xx, a, c) * fooC2(xx, a) * fooD2(xx, a, c) * fooE(xx);
      var y = yy * height / 10;
      path.lineTo(x + 0.0, y + height / 2);
    }
    path.close();
    canvas.drawPath(path, p);
  }

  //录音结束后的评估过程中，图形左右来回走动
  void updateWaveEvaluate() {
    var curveWidth = 20;
    var curveThick = 1.5;
    var validWidth = width - curveWidth;
    Path path = new Path();
    Paint p = new Paint()
      ..color = mainColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    //元素的位置
    x = tick % validWidth + curveWidth / 2;
    if (x < width / 2) {
      x = x * 2 - curveWidth;
    } else {
      x = 2 * (width - x) - curveWidth;
    }
    //上半部分
    for (var k = 0; k <= curveWidth; k += 1) {
      var yy = height / 2 - curveThick * sin(pi * k / curveWidth);
      if (k == 0) {
        path.moveTo(x + k + 0.0, yy);
      } else {
        path.lineTo(x + k + 0.0, yy);
      }
    }
    //下半部分
    for (var k = curveWidth; k >= 0; k -= 1) {
      var yy = height / 2 + curveThick * sin(pi * k / curveWidth);
      path.lineTo(x + k + 0.0, yy);
    }
    path.close();
    canvas.drawPath(path, p);
    canvas.drawLine(new Offset(curveWidth / 2, height / 2), new Offset(width - curveWidth / 2, height / 2), p);
  }

  //录音停止，开始评测
  stop() {
    updateWaveEvaluate();
  }

  //录音开始，绘制波形
  start() {
    updateWave1();
    updateWave2();
  }
}
