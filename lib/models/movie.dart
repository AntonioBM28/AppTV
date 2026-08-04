import 'package:flutter/material.dart';

class Movie {

  final String title;
  final String year;
  final String genre;
  final double rating;
  final String description;
  final Color color1;
  final Color color2;
  final IconData icon;

  Movie({
  required this.title, 
  required this.year, 
  required this.genre, 
  required this.rating, 
  required this.description, 
  required this.color1, 
  required this.color2, 
  required this.icon});
}