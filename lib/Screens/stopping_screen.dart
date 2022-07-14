import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoppingScreen extends StatelessWidget {
  final String text;

  const StoppingScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/background8.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/speed_and_success.png',
                      height: 180,
                      width: 240,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text,
                        softWrap: true,
                        maxLines: 3,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
