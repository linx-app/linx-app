import 'package:flutter/material.dart';

class SearchCategoryCard extends StatelessWidget {
  final String category;

  const SearchCategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(""),
                  fit: BoxFit.cover,
                )
            ),
            child: Text(""),
          ),
      ),
    );
  }

}