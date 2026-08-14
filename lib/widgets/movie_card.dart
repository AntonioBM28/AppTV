import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_app/models/movie.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback onSelect;
  final bool autofocus;
  
  const MovieCard({
    super.key, 
    required this.movie, 
    required this.onSelect, 
    required this.autofocus,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.autofocus,
      onFocusChange: (focused) => setState(() => _focused = focused),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.gameButtonA)) {
          widget.onSelect();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onSelect,
        child: AnimatedScale(
          scale: _focused ? 1.06 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [widget.movie.color1, widget.movie.color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: _focused
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.08),
                width: _focused ? 2.5 : 1,
              ),
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: widget.movie.color1.withValues(alpha: 0.5),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.1),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icono con fondo semitransparente
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                    child: Icon(widget.movie.icon, size: 36, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.movie.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.movie.year,
                    style: GoogleFonts.outfit(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Rating pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 13),
                        const SizedBox(width: 3),
                        Text(
                          widget.movie.rating.toString(),
                          style: GoogleFonts.outfit(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Badge de género
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.movie.genre.toUpperCase(),
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}