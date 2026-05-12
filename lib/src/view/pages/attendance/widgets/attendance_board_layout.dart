import 'package:flutter/material.dart';
import 'package:uyoung/data/font_style.dart';
import 'package:uyoung/data/image_data.dart';
import 'package:uyoung/src/viewModel/attendance/attendance_view_model.dart';

class AttendanceBoardLayout extends StatelessWidget {
  const AttendanceBoardLayout({super.key, required this.viewModel});

  final AttendanceViewModel viewModel;
  static const _boardAspectRatio = 1192 / 1292;
  static const _starPoints = <_BoardPoint>[
    _BoardPoint(day: 1, x: 0.14, y: 0.17),
    _BoardPoint(day: 2, x: 0.49, y: 0.14),
    _BoardPoint(day: 3, x: 0.84, y: 0.30),
    _BoardPoint(day: 4, x: 0.49, y: 0.48),
    _BoardPoint(day: 5, x: 0.10, y: 0.64),
    _BoardPoint(day: 6, x: 0.37, y: 0.79),
    _BoardPoint(day: 7, x: 0.81, y: 0.78),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final labelStyle = AppFontStyle.H6.copyWith(
          color: const Color(0xFF6EA8EB),
        );

        final boardWidth = constraints.maxWidth;
        final boardHeight = constraints.maxHeight;
        final pathWidth = boardWidth - 18;
        final imageHeight = pathWidth / _boardAspectRatio;
        final availableHeight = boardHeight - 18;
        final pathHeight = imageHeight > availableHeight
            ? availableHeight
            : imageHeight;
        final actualPathWidth = pathHeight * _boardAspectRatio;
        final leftInset = (boardWidth - actualPathWidth) / 2;
        final topInset = boardHeight - pathHeight - 2;
        final starWidth = actualPathWidth * 0.285;
        final iconSize = starWidth * 0.47;
        final labelTopGap = starWidth * 0.70;

        return Stack(
          children: [
            Positioned(
              left: leftInset,
              top: topInset,
              width: actualPathWidth,
              height: pathHeight,
              child: Image.asset(
                ImagePath.attendanceBoardPath,
                fit: BoxFit.contain,
              ),
            ),
            for (final point in _starPoints)
              _BoardTile(
                left: leftInset + (actualPathWidth * point.x) - (starWidth / 2),
                top: topInset + (pathHeight * point.y) - (starWidth / 2),
                day: point.day,
                starWidth: starWidth,
                iconSize: iconSize,
                labelTopGap: labelTopGap,
                imagePath: viewModel.boardItemPathForDay(point.day),
                highlighted: point.day == 7 && viewModel.checkedDays >= 7,
                labelStyle: labelStyle,
              ),
          ],
        );
      },
    );
  }
}

class _BoardPoint {
  const _BoardPoint({
    required this.day,
    required this.x,
    required this.y,
  });

  final int day;
  final double x;
  final double y;
}

class _BoardTile extends StatelessWidget {
  const _BoardTile({
    required this.left,
    required this.top,
    required this.day,
    required this.starWidth,
    required this.iconSize,
    required this.imagePath,
    required this.labelStyle,
    required this.labelTopGap,
    this.highlighted = false,
  });

  final double left;
  final double top;
  final int day;
  final double starWidth;
  final double iconSize;
  final String imagePath;
  final TextStyle labelStyle;
  final double labelTopGap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: starWidth,
        height: starWidth + labelTopGap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (highlighted)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x66FFF5A6),
                        blurRadius: starWidth * 0.20,
                        spreadRadius: starWidth * 0.05,
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              left: 0,
              top: 0,
              width: starWidth,
              height: starWidth,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      ImagePath.attendanceBoardStar,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Image.asset(
                        imagePath,
                        width: iconSize,
                        height: iconSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: labelTopGap,
              child: Text(
                '$day일차',
                style: labelStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
