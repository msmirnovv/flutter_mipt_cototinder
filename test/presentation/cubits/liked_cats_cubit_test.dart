import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kototinder/presentation/cubits/liked_cats_cubit.dart';
import 'package:kototinder/domain/models/cat_model.dart';
import 'package:kototinder/data/local/app_database.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockCatRow extends Mock implements Cat {}

void main() {
  late LikedCatsCubit likedCatsCubit;
  late MockAppDatabase mockDb;

  setUp(() {
    mockDb = MockAppDatabase();

    // Настроить мок сразу
    when(() => mockDb.allCachedCats).thenAnswer((_) async => []);

    likedCatsCubit = LikedCatsCubit(mockDb);
  });

  tearDown(() async {
    await likedCatsCubit.close();
  });

  group('LikedCatsCubit', () {
    final testCat = CatModel(
      url: 'https://example.com/cat.jpg',
      breed: 'Siamese',
      description: 'Test cat',
      temperament: 'Friendly',
      origin: 'Thailand',
    );

    test('initial state is empty list', () {
      expect(likedCatsCubit.state, []);
    });

    test('likeCat adds a cat to liked list', () async {
      when(
        () => mockDb.updateLike(any(), true, any()),
      ).thenAnswer((_) async => {});
      when(() => mockDb.allCachedCats).thenAnswer(
        (_) async => [
          Cat(
            url: testCat.url,
            breed: testCat.breed,
            description: testCat.description,
            temperament: testCat.temperament,
            origin: testCat.origin,
            liked: true,
            likedAt: DateTime.now(),
          ),
        ],
      );

      await likedCatsCubit.likeCat(testCat);

      expect(likedCatsCubit.state.length, 1);
      expect(likedCatsCubit.state.first.cat.url, testCat.url);
    });

    test('removeCat removes a cat from liked list', () async {
      when(
        () => mockDb.updateLike(any(), false, null),
      ).thenAnswer((_) async => {});
      when(() => mockDb.allCachedCats).thenAnswer((_) async => []);

      final likedCat = LikedCat(cat: testCat, likedAt: DateTime.now());

      await likedCatsCubit.removeCat(likedCat);

      expect(likedCatsCubit.state, isEmpty);
    });
  });
}
