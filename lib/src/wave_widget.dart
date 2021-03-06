/*
 * Created by yeongguo on 10/09/21 20:33 PM
 * Copyright (c) 2018 Tencent
 *
 * Description:
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'wave_voice_painter.dart';

enum VoiceWaveType {
  recording,
  loading,
  finished,
}

class VoiceWaveWidget extends StatefulWidget {
  final VoiceWaveType type;
  final double? volume;

  VoiceWaveWidget({this.type = VoiceWaveType.recording, this.volume});

  @override
  _VoiceWaveWidgetState createState() => _VoiceWaveWidgetState();
}

class _VoiceWaveWidgetState extends State<VoiceWaveWidget> with SingleTickerProviderStateMixin {
  int _tick = 0;
  late AnimationController controller;
  var _curVolume = 0.0;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(vsync: this, duration: new Duration(seconds: 1000))..addListener(_listener);
    _updateStatus();
  }

  void _listener() {
    if (mounted) {
      _tick += 5;
      _curVolume = widget.volume ?? 50;
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    controller.dispose();
    super.dispose();
  }

  void _updateStatus() {
    if (widget.type == VoiceWaveType.recording || widget.type == VoiceWaveType.loading) {
      if (widget.type == VoiceWaveType.recording) {
        _tick = 0;
      }
      controller.forward();
    } else {
      _tick = 0;
      controller.stop();
    }
  }

  @override
  void didUpdateWidget(covariant VoiceWaveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mounted) {
      _updateStatus();
      controller.removeListener(_listener);
      controller.addListener(_listener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, BoxConstraints size) {
      return new Container(
        width: size.maxWidth * 0.9,
        height: size.maxHeight,
        child: new CustomPaint(
          painter: new VoiceWavePainter(
            volume: _curVolume,
            status: widget.type,
            tick: _tick,
          ),
        ),
      );
    });
  }
}
