/*
 * Created by yeongguo on 10/09/21 20:33 PM
 * Copyright (c) 2018 Tencent
 *
 * Description:
 */

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'wave_line.dart';
import 'wave_widget.dart';

double waveA = 0.75;
double waveC = 0.0;
double waveD = 1.0;

double lastWaveA = 0.0;

class VoiceWavePainter extends CustomPainter {
  VoiceWavePainter({
    required this.tick,
    required this.status,
    this.volume = 0.0,
  }) : super() {
    if (waveC > 10) {
      waveD = -1.0;
    } else if (waveC < -10) {
      waveD = 1.0;
    }
    waveC = waveC + 0.13 * waveD;
    waveA += (volume / (30.0) - lastWaveA) / 7; // 300
    if (waveA < 0.1) {
      waveA = 0.1;
    } else if (waveA > 1) {
      waveA = 1.0;
    }
    a = waveA;
    d = waveD;
    c = waveC;

    lastWaveA = a;
  }

  double volume;
  WaveLine? w;
  late Timer timer;
  double a = waveA, d = waveD, c = waveC;
  num tick;
  var status;

  @override
  void paint(Canvas canvas, Size size) {
    if (w == null) {
      w = new WaveLine(
        canvas: canvas,
        width: size.width,
        height: size.height,
        waveA: a,
        waveC: c,
        waveD: d,
        tick: tick,
      );
    }
    w?.setCanvas(canvas);
    if (status == VoiceWaveType.recording) {
      w?.start();
    } else if (status == VoiceWaveType.loading) {
      w?.stop();
    } else {}
  }

  @override
  bool shouldRepaint(VoiceWavePainter oldDelegate) {
    return true;
  }
}
