// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:nice_image/core/di/injection.dart' as _i107;
import 'package:nice_image/core/network/dio_http_client.dart' as _i883;
import 'package:nice_image/core/network/http_client.dart' as _i979;
import 'package:nice_image/core/services/image_palette_service.dart' as _i173;
import 'package:nice_image/core/services/palette_generator_service.dart'
    as _i721;
import 'package:nice_image/features/random_image/data/datasources/random_image_remote_datasource.dart'
    as _i700;
import 'package:nice_image/features/random_image/data/repositories/random_image_repository_impl.dart'
    as _i1017;
import 'package:nice_image/features/random_image/domain/repositories/random_image_repository.dart'
    as _i879;
import 'package:nice_image/features/random_image/presentation/cubit/random_image_cubit.dart'
    as _i452;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.lazySingleton<_i173.ImagePaletteService>(
      () => _i721.PaletteGeneratorService(),
    );
    gh.lazySingleton<_i979.HttpClient>(
      () => _i883.DioHttpClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i700.RandomImageRemoteDataSource>(
      () => _i700.RandomImageRemoteDataSourceImpl(gh<_i979.HttpClient>()),
    );
    gh.lazySingleton<_i879.RandomImageRepository>(
      () => _i1017.RandomImageRepositoryImpl(
        gh<_i700.RandomImageRemoteDataSource>(),
      ),
    );
    gh.factory<_i452.RandomImageCubit>(
      () => _i452.RandomImageCubit(
        gh<_i879.RandomImageRepository>(),
        gh<_i173.ImagePaletteService>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i107.NetworkModule {}
