import 'package:flutter/material.dart';

class QuizApp extends StatelessWidget {
  void answerQuestion() {
    print('Answer chosen!');
  }

  @override
  Widget build(BuildContext context) {
    var questionIndex = 0;

    void answerQuestion() {
      questionIndex = questionIndex + 1;
      print(questionIndex);
    }

    var questions = [
      'What\'s your favorite color?',
      'What\'s your favorite animarl?',
    ];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My First App'),
        ),
        body: Column(
          children: [
            const Text('The question!'),
            ElevatedButton(
              onPressed: answerQuestion,
              child: const Text('Answer 1'),
            ),
            ElevatedButton(
              onPressed: () => print('Answer 2 chosen!'),
              child: const Text('Answer 2'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Answer 3 chosen');
              },
              child: const Text('Answer 3'),
            ),
          ],
        ),
      ),
    );
  }
}
