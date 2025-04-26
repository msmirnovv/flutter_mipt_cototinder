import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'di/locator.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/cubits/cat_cubit.dart';
import 'presentation/cubits/liked_cats_cubit.dart';
import 'presentation/cubits/connectivity_cubit.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ConnectivityCubit>()),
        BlocProvider(create: (_) => sl<CatCubit>()..fetchRandomCat()),
        BlocProvider(create: (_) => sl<LikedCatsCubit>()),
      ],
      child: MaterialApp(
        title: 'Кототиндер',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: BlocListener<ConnectivityCubit, ConnectivityState>(
          listener: (context, state) {
            final text = state.online ? 'Сеть восстановлена' : 'Вы оффлайн';
            final color = state.online ? Colors.green : Colors.red;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(text), backgroundColor: color),
              );
            if (state.online) {
              context.read<CatCubit>().fetchRandomCat();
            } else {
              context.read<CatCubit>().fetchOfflineCat();
            }
          },
          child: MainScreen(),
        ),
      ),
    );
  }
}
