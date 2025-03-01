// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: './.env.dev')
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY', defaultValue: '', obfuscate: true)
  static String openAiApiKey = _Env.openAiApiKey;
  @EnviedField(varName: 'UPSTAGE_API_KEY', defaultValue: '', obfuscate: true)
  static String upstageApiKey = _Env.upstageApiKey;
  @EnviedField(varName: 'GEMINI_API_KEY', defaultValue: '', obfuscate: true)
  static String geminiApiKey = _Env.geminiApiKey;
}
