import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_app/models/movie.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback onSelect;
  final bool autofocus;
  
  const MovieCard({
  super.key, 
  required this.movie, 
  required this.onSelect, 
  required this.autofocus
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
        (
          event.logicalKey == LogicalKeyboardKey.select ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.gameButtonA
        )
        )
        {
          widget.onSelect();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onSelect,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [widget.movie.color1, widget.movie.color2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: _focused ? Colors.white : Colors.transparent,
              width: 3,
            ),
            boxShadow: _focused
                ? [BoxShadow(color: Colors.white38, blurRadius: 16, spreadRadius: 2)]
                : [],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.movie.icon, size: 48, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  widget.movie.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.movie.year,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      widget.movie.rating.toString(),
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}