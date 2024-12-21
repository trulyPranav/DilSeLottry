import 'package:flutter/material.dart';

Widget landingCard(context, title, description, {extra = const Center()}){
  return Container(
    height: MediaQuery.of(context).size.width * 1.45,
    width: MediaQuery.of(context).size.width * 0.9,
    margin: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: LinearGradient(
        colors: [
          Colors.blueAccent,
          Colors.redAccent
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: [0.2,0.9]
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(40, 30, 40, 33),
          child: Column(
            children: [
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: 150,
              ),
              extra
            ],
          ),
        )
      ],
    ),
  );
}