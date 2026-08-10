// Generates assets/images/app_icon_master.png for flutter_launcher_icons.
// Default source: assets/images/logoIcon.png.
// Usage: dart run tool/pad_app_icon.dart [logoFraction] [sourcePath]
// logoFraction: max share of canvas used by logo width/height (default 0.64).
// sourcePath: optional path under project root (e.g. assets/images/foo.png).
import 'dart:io';

import 'package:image/image.dart';

void main(List<String> args) {
  const canvasSize = 1024;
  double logoFraction = 0.64;
  String? sourceRel;
  if (args.isNotEmpty) {
    final a0 = args[0];
    final asFrac = double.tryParse(a0);
    if (asFrac != null) {
      logoFraction = asFrac;
      if (args.length > 1) sourceRel = args[1];
    } else {
      sourceRel = a0;
    }
  }

  final root = Directory.current.path;
  final src = File(
    '$root/${sourceRel ?? 'assets/images/logoIcon.png'}',
  );
  final out = File('$root/assets/images/app_icon_master.png');

  final logo = decodeImage(src.readAsBytesSync());
  if (logo == null) {
    stderr.writeln('Failed to decode ${src.path}');
    exit(1);
  }

  final maxSide = (canvasSize * logoFraction).round();
  final w = logo.width;
  final h = logo.height;
  final scale = maxSide / (w > h ? w : h);
  final newW = (w * scale).round().clamp(1, maxSide);
  final newH = (h * scale).round().clamp(1, maxSide);

  final scaled = copyResize(
    logo,
    width: newW,
    height: newH,
    interpolation: Interpolation.average,
  );

  final canvas = Image(width: canvasSize, height: canvasSize, numChannels: 4);
  fill(canvas, color: ColorRgba8(255, 255, 255, 255));

  compositeImage(
    canvas,
    scaled,
    dstX: (canvasSize - newW) ~/ 2,
    dstY: (canvasSize - newH) ~/ 2,
  );

  out.writeAsBytesSync(encodePng(canvas));
  stdout.writeln('Wrote ${out.path} (logoFraction=$logoFraction)');
}
