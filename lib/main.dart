import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

//! Define a list of names
const names = [
  'Foo',
  'Bar',
  'Baz',
];

//! We need to pick random names
//! extension RandomElement<T> on Iterable<T>

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

//! Cubits are really just streams and controllers

//! Cubit class definition
//? class NamesCubit extends Cubit<String?>

class NamesCubit extends Cubit<String?> {
  //! Constructor

  NamesCubit() : super(null);

  //! Allow picking random names in the cubit
  //? void pickRandomName() => emit(names.getRandomELement());

  void pickRandomName() => emit(
        names.getRandomElement(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//! Define a cubit in your _HomePageState
//? late final NamesCubit cubit;

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;

//! Initialize your cubit in initState()
//! cubit = NamesCubit();

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

//! Close your cubit in dispose()
  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

//! StreamBuilder for the body of Scaffold
//! stream:cubit.stream
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        //! Define a TextButton in buider()

        //! Handle various connection states
        //! ConnectionState.active is the most important for us

        builder: (context, snapshot) {
          final button = TextButton(
            onPressed: () {
              cubit.pickRandomName();
            },
            child: Text('Pick a random name'),
          );
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;
            case ConnectionState.waiting:
              return button;
            case ConnectionState.active:
              return Column(
                children: [
                  Text(
                    snapshot.data ?? '',
                  ),
                  button,
                ],
              );
            case ConnectionState.done:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
