import 'package:flutter/material.dart';
import 'package:hostelkube_frontend/src/features/widgets/pallete.dart';

class loginButton extends StatelessWidget {
  const loginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Pallete.gradient1,
            Pallete.gradient2,
            // Pallete.gradient3 ,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(350, 45),
          backgroundColor: Colors.transparent,
          // shadowColor: Colors.transparent,
        ),
        child: const Text(
          'Log in',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
