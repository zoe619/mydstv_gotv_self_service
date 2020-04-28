import 'package:flutter/material.dart';

class ProfileClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
//    this draws a line from d top left corner X axis to 4/5 of the height of the image
    path.lineTo(0, 4 * size.height / 5);
    //this draws a curve line from the 4/5th position to half the size of the width of the image
    Offset curvePoint = Offset(size.width / 2, size.height);
//    draw a curve from the center position where u left off to d end of the image
    Offset endPoint = Offset(size.width, 4 * size.height / 5);

    path.quadraticBezierTo(
        curvePoint.dx,
        curvePoint.dy,
        endPoint.dx,
        endPoint.dy
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }

}