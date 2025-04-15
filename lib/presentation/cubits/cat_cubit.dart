import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/cat_model.dart';
import '../../domain/repositories/cat_repository.dart';

abstract class CatState {}

class CatInitial extends CatState {}

class CatLoading extends CatState {}

class CatLoaded extends CatState {
  final CatModel cat;
  CatLoaded(this.cat);
}

class CatError extends CatState {
  final String message;
  CatError(this.message);
}

class CatCubit extends Cubit<CatState> {
  final CatRepository repository;

  CatCubit(this.repository) : super(CatInitial());

  Future<void> fetchRandomCat() async {
    emit(CatLoading());
    try {
      final cat = await repository.fetchRandomCat();
      emit(CatLoaded(cat));
    } catch (e) {
      emit(CatError(e.toString()));
    }
  }
}
