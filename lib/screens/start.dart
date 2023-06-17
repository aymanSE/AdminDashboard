import 'package:flutter/material.dart';

class start extends StatelessWidget {
  start({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136.0,
      height: 49.0,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/signin");
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
            backgroundColor:
                MaterialStateProperty.all(const Color(0xffe4e4e4))),
        child: const Text(
          "Get Started",
          style: TextStyle(
            fontFamily: 'Rockwell',
            fontSize: 15,
            color: Color(0xff1e1c1c),
          ),
        ),
      ),
    );
  }
}
