import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_app/models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // Índice del botón actualmente enfocado (0=Ver ahora, 1=Favorito, 2=Volver)
  int _focusedButton = 0;
  final int _totalButtons = 3;

  final List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
    // Dar el foco al primer botón al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _moveFocus(int direction) {
    final next = (_focusedButton + direction).clamp(0, _totalButtons - 1);
    if (next != _focusedButton) {
      setState(() => _focusedButton = next);
      _focusNodes[next].requestFocus();
    }
  }

  KeyEventResult _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        _moveFocus(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _moveFocus(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
      case LogicalKeyboardKey.backspace:
      case LogicalKeyboardKey.goBack:
        context.pop();
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _handleKey,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Row(
              children: [
                // ─── PANEL IZQUIERDO — Visual de la película ───────────────
                Expanded(
                  flex: 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradiente de fondo de la película
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [movie.color1, movie.color2],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),

                      // Overlay oscuro sobre el gradiente
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.black.withValues(alpha: 0.6),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      // Icono central grande
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              movie.icon,
                              size: 120,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            const SizedBox(height: 24),
                            _GenreChip(genre: movie.genre),
                          ],
                        ),
                      ),

                      // Flecha para regresar (top-left)
                      Positioned(
                        top: 32,
                        left: 32,
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                  color: Colors.white24, width: 1),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.arrow_back_ios_new,
                                    color: Colors.white, size: 16),
                                SizedBox(width: 6),
                                Text('Volver',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Gradiente lateral derecho (efecto de transición)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                const Color(0xFF0A0A0F),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── PANEL DERECHO — Info + botones ────────────────────────
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Año
                        Text(
                          movie.year,
                          style: TextStyle(
                            color: movie.color1,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Título
                        Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Rating
                        _RatingRow(rating: movie.rating, color: movie.color1),
                        const SizedBox(height: 28),

                        // Línea divisora
                        Container(
                          height: 1,
                          color: Colors.white12,
                        ),
                        const SizedBox(height: 28),

                        // Descripción
                        Text(
                          movie.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // ── Botones de acción ──
                        Text(
                          'Usa ↑ ↓ para navegar y Enter para seleccionar',
                          style: TextStyle(
                            color: Colors.white30,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _ActionButton(
                          focusNode: _focusNodes[0],
                          label: 'Ver ahora',
                          icon: Icons.play_arrow_rounded,
                          isPrimary: true,
                          color: movie.color1,
                          isFocused: _focusedButton == 0,
                          onPressed: () {
                            // TODO: reproducir película
                          },
                        ),
                        const SizedBox(height: 16),

                        _ActionButton(
                          focusNode: _focusNodes[1],
                          label: 'Agregar a favoritos',
                          icon: Icons.favorite_border_rounded,
                          isPrimary: false,
                          color: movie.color1,
                          isFocused: _focusedButton == 1,
                          onPressed: () {
                            // TODO: agregar a favoritos
                          },
                        ),
                        const SizedBox(height: 16),

                        _ActionButton(
                          focusNode: _focusNodes[2],
                          label: 'Volver al inicio',
                          icon: Icons.arrow_back_rounded,
                          isPrimary: false,
                          color: Colors.white38,
                          isFocused: _focusedButton == 2,
                          onPressed: () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Widget: Chip de género ─────────────────────────────────────────────────
class _GenreChip extends StatelessWidget {
  final String genre;
  const _GenreChip({required this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white30, width: 1),
      ),
      child: Text(
        genre.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

// ─── Widget: Fila de rating con estrellas ───────────────────────────────────
class _RatingRow extends StatelessWidget {
  final double rating;
  final Color color;
  const _RatingRow({required this.rating, required this.color});

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor();
    final hasHalf = (rating - fullStars) >= 0.5;

    return Row(
      children: [
        for (int i = 0; i < 5; i++)
          Icon(
            i < fullStars
                ? Icons.star_rounded
                : (i == fullStars && hasHalf)
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
            color: Colors.amber,
            size: 24,
          ),
        const SizedBox(width: 12),
        Text(
          rating.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          '/ 5.0',
          style: TextStyle(color: Colors.white38, fontSize: 14),
        ),
      ],
    );
  }
}

// ─── Widget: Botón de acción TV-style ──────────────────────────────────────
class _ActionButton extends StatefulWidget {
  final FocusNode focusNode;
  final String label;
  final IconData icon;
  final bool isPrimary;
  final Color color;
  final bool isFocused;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.focusNode,
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.color,
    required this.isFocused,
    required this.onPressed,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.gameButtonA)) {
          widget.onPressed();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 320,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          decoration: BoxDecoration(
            color: widget.isFocused
                ? (widget.isPrimary ? widget.color : Colors.white12)
                : (widget.isPrimary
                    ? widget.color.withValues(alpha: 0.2)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isFocused
                  ? (widget.isPrimary ? widget.color : Colors.white54)
                  : Colors.white12,
              width: widget.isFocused ? 2 : 1,
            ),
            boxShadow: widget.isFocused && widget.isPrimary
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: widget.isFocused ? Colors.white : Colors.white54,
                size: 22,
              ),
              const SizedBox(width: 14),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.isFocused ? Colors.white : Colors.white54,
                  fontSize: 16,
                  fontWeight: widget.isFocused
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
              if (widget.isFocused) ...[
                const Spacer(),
                const Icon(Icons.chevron_right_rounded,
                    color: Colors.white70, size: 20),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
