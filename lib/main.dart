import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';

// Data
import 'data/datasources/cv_local_datasource.dart';
import 'data/datasources/cv_remote_datasource.dart';
import 'data/repositories/cv_repository_impl.dart';
import 'data/repositories/settings_repository_impl.dart';

// Domain
import 'domain/usecases/analyze_cv_usecase.dart';
import 'domain/usecases/history_usecases.dart';
import 'domain/usecases/settings_usecases.dart';

// Presentation
import 'presentation/providers/cv_provider.dart';
import 'presentation/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure system UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Initialize DataSources
  final remoteDataSource = CvRemoteDataSource();
  final localDataSource = CvLocalDataSource();
  
  // Initialize Repositories
  final cvRepository = CvRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
  final settingsRepository = SettingsRepositoryImpl();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CvProvider(
            analyzeCvUseCase: AnalyzeCvUseCase(cvRepository),
            getHistoryUseCase: GetHistoryUseCase(cvRepository),
            deleteHistoryUseCase: DeleteHistoryUseCase(cvRepository),
            clearHistoryUseCase: ClearHistoryUseCase(cvRepository),
            getApiKeyUseCase: GetApiKeyUseCase(settingsRepository),
            saveApiKeyUseCase: SaveApiKeyUseCase(settingsRepository),
          )..init(),
        ),
      ],
      child: const CvGeneratorApp(),
    ),
  );
}

class CvGeneratorApp extends StatelessWidget {
  const CvGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}
