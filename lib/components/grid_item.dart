import 'package:flutter/material.dart';

class FCGridItem extends StatelessWidget {
  const FCGridItem({ Key? key, required this.color, required this.title, required this.subtitle, required this.amount }) : super(key: key);

  final Color color;
  final String title;
  final String subtitle;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: const BorderRadius.all(Radius.circular(6))
        ),
        height: 110,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              Text(subtitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),),
              const SizedBox(height: 10,),
              Text(amount.toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}