import 'package:flutter/material.dart';

import '../../../../domain/entities/dependency.dart';
import '../../themes/colors.dart';

class VadenDependenciesCard extends StatelessWidget {
  final List<Dependency> dependencies;
  final Function(Dependency) onRemove;

  const VadenDependenciesCard({
    super.key,
    required this.dependencies,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final dependency in dependencies)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: VadenColors.stkSupport2,
                width: 1,
              ),
            ),
            margin: const EdgeInsets.only(top: 10),
            child: _buildDependencyItem(context, dependency),
          ),
      ],
    );
  }

  Widget _buildDependencyItem(BuildContext context, Dependency dependency) {
    // Usar padding vertical de 12 quando houver apenas uma dependência
    final verticalPadding = dependencies.length == 1 ? 12.0 : 4.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: verticalPadding),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dependency.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: VadenColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  dependency.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: VadenColors.txtSupport3,
                        fontWeight: FontWeight.w300,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            onTap: () => onRemove(dependency),
            child: _buildCloseButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(left: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo com borda em degradê
          CustomPaint(
            size: const Size(28, 28),
            painter: GradientCirclePainter(
              gradientColors: [
                VadenColors.gradientStart,
                VadenColors.gradientEnd,
              ],
              strokeWidth: 2.0,
            ),
          ),
          // Ícone X em degradê
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  VadenColors.gradientStart,
                  VadenColors.gradientEnd,
                ],
              ).createShader(bounds);
            },
            child: const Icon(
              Icons.close,
              size: 18,
              color: VadenColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Classe para desenhar o círculo com gradiente
class GradientCirclePainter extends CustomPainter {
  final List<Color> gradientColors;
  final double strokeWidth;

  GradientCirclePainter({
    required this.gradientColors,
    this.strokeWidth = 1.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Desenhar o círculo com gradiente
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
