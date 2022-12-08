import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final void Function() selectHandler;
  final String answerText;

  const Answer(this.selectHandler, this.answerText, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16.0),
          textStyle: const TextStyle(fontSize: 20),
        ),
        onPressed: selectHandler,
        child: Text(answerText),
      ),
    );
  }
}
