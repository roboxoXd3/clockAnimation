// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BetterClockPage extends StatefulWidget {
  const BetterClockPage({super.key});

  @override
  _BetterClockPageState createState() => _BetterClockPageState();
}

class _BetterClockPageState extends State<BetterClockPage> {
  DateTime _dateTime = DateTime.now();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF2196F3), // Lighter blue background
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'STUNNING CLOCK',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Container(
                width: 250,
                height: 250,
                child: CustomPaint(
                  painter: ClockPainter(_dateTime),
                ),
              ),
              Column(
                children: [
                  Text(
                    DateFormat('EEEE').format(_dateTime),
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    DateFormat('MMMM d, y').format(_dateTime),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  DateFormat('HH:mm:ss').format(_dateTime),
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime dateTime;

  ClockPainter(this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    // Clock face
    var outlineBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    var centerFillBrush = Paint()..color = Colors.white;

    var secondHandBrush = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    var minuteHandBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    var hourHandBrush = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    // Draw clock face
    canvas.drawCircle(center, radius - 10, outlineBrush);

    // Draw hour markers
    for (int i = 0; i < 12; i++) {
      double angle = i * 30 * pi / 180;
      double markerLength = 10;
      double x1 = centerX + (radius - 15) * cos(angle);
      double y1 = centerY + (radius - 15) * sin(angle);
      double x2 = centerX + (radius - 15 - markerLength) * cos(angle);
      double y2 = centerY + (radius - 15 - markerLength) * sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), outlineBrush);
    }

    // Hour hand
    double hourAngle = (dateTime.hour % 12 + dateTime.minute / 60) * 30;
    var hourHandX = centerX + 50 * cos((hourAngle - 90) * pi / 180);
    var hourHandY = centerY + 50 * sin((hourAngle - 90) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    // Minute hand
    double minuteAngle = dateTime.minute * 6;
    var minHandX = centerX + 65 * cos((minuteAngle - 90) * pi / 180);
    var minHandY = centerY + 65 * sin((minuteAngle - 90) * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minuteHandBrush);

    // Second hand
    double secondAngle = dateTime.second * 6;
    var secHandX = centerX + 70 * cos((secondAngle - 90) * pi / 180);
    var secHandY = centerY + 70 * sin((secondAngle - 90) * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secondHandBrush);

    // Center dot
    canvas.drawCircle(center, 4, centerFillBrush);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
