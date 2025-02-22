import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PoweredByWidget extends StatelessWidget {
  const PoweredByWidget({super.key, required this.opacity});
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8.0,
      left: 0.0,
      right: 0.0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        opacity: opacity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Powered By ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SvgPicture.asset(
              'assets/images/hive.svg',
              width: 50,
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
