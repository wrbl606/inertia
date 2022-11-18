import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:inertia/inertia.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Inertia example',
        theme: ThemeData(
          colorSchemeSeed: Colors.amber,
          useMaterial3: true,
        ),
        home: PageView(
          children: const [
            Page(
              title: 'Dynamic spacing',
              child: ListWithSpacing(),
            ),
            Page(
              title: 'Motion blur',
              child: ListWithMotionBlur(),
            ),
          ],
        ),
      );
}

class Page extends StatelessWidget {
  const Page({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  void _toggleTimeDilation() {
    timeDilation = timeDilation == 10 ? 1 : 10;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
              onPressed: _toggleTimeDilation,
              icon: const Icon(Icons.timelapse),
            ),
          ],
        ),
        body: child,
      );
}

class ListWithSpacing extends StatefulWidget {
  const ListWithSpacing({super.key});

  @override
  State<ListWithSpacing> createState() => _ListWithSpacingState();
}

class _ListWithSpacingState extends State<ListWithSpacing> {
  static const sequence = [
    Alignment.centerLeft,
    Alignment.centerLeft,
    Alignment.centerLeft,
    Alignment.centerLeft,
    Alignment.centerLeft,
    Alignment.centerLeft,
    Alignment.centerRight,
    Alignment.centerRight,
    Alignment.centerRight,
  ];
  final colors = {
    Alignment.centerRight: Colors.amber,
    Alignment.centerLeft: Colors.grey.shade200,
  };
  int seqIterator = 0;

  @override
  Widget build(BuildContext context) => InertiaListener(
        child: ListView.builder(
          itemBuilder: (context, index) {
            seqIterator = (++seqIterator) % sequence.length;
            return Align(
              alignment: sequence[seqIterator],
              child: InertiaSpacing(
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .6),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 1,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: colors[sequence[seqIterator]],
                  ),
                  child: Text(faker.lorem
                      .sentences(Random().nextInt(2) + 1)
                      .join('. ')),
                ),
              ),
            );
          },
        ),
      );
}

class ListWithMotionBlur extends StatefulWidget {
  const ListWithMotionBlur({super.key});

  @override
  State<ListWithMotionBlur> createState() => _ListWithMotionBlur();
}

class _ListWithMotionBlur extends State<ListWithMotionBlur> {
  static const _images = [
    'assets/example1.jpg',
    'assets/example2.jpg',
    'assets/example3.jpg',
    'assets/example4.jpg',
    'assets/example5.jpg',
    'assets/example6.jpg',
    'assets/example7.jpg',
    'assets/example8.jpg',
    'assets/example9.jpg',
    'assets/example10.jpg',
  ];
  int seqIterator = 0;

  @override
  Widget build(BuildContext context) => InertiaListener(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemBuilder: (context, index) => MotionBlur(
            maxBlur: 10,
            deadZone: 10,
            child: Image.asset(
              _images[seqIterator++ % _images.length],
            ),
          ),
        ),
      );
}
