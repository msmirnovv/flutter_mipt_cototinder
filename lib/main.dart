import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'di/locator.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/cubits/cat_cubit.dart';
import 'presentation/cubits/liked_cats_cubit.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CatCubit>()..fetchRandomCat()),
        BlocProvider(create: (_) => sl<LikedCatsCubit>()),
      ],
      child: MaterialApp(
        title: 'Кототиндер',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MainScreen(),
      ),
    );
  }
}
