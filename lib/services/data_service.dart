import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/topic_model.dart';
import '../models/flashcard_model.dart';
import '../models/quiz_model.dart';

class DataService {
  static final DataService _instance = DataService._internal();

  factory DataService() {
    return _instance;
  }

  DataService._internal();

  /// ✅ Tải danh sách topics
  Future<List<Topic>> loadTopics() async {
    try {
      final jsonString = await rootBundle.loadString('data/topics.json');
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final topics = (jsonData['topics'] as List)
          .map((item) => Topic.fromJson(item as Map<String, dynamic>))
          .toList();
      return topics;
    } catch (e) {
      print('Error loading topics: $e');
      return [];
    }
  }

  /// ✅ Tải flashcards cho topic cụ thể
  Future<List<Flashcard>> loadFlashcardsForTopic(String topicId) async {
    try {
      // Map topicId sang tên file
      final Map<String, String> fileMap = {
        'animals': 'data/flashcards/animals_flashcards.json',
        'fruits': 'data/flashcards/fruits_flashcards. json',
        'colors': 'data/flashcards/colors_flashcards.json',
        'shapes': 'data/flashcards/shapes_flashcards.json',
        'vehicles': 'data/flashcards/vehicles_flashcards.json',
        'alphabet': 'data/flashcards/alphabet_flashcards.json',
      };

      final filePath =
          fileMap[topicId] ?? 'data/flashcards/animals_flashcards.json';
      final jsonString = await rootBundle.loadString(filePath);
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      final flashcards = (jsonData['flashcards'] as List)
          .map((item) => Flashcard.fromJson(item as Map<String, dynamic>))
          .toList();

      return flashcards;
    } catch (e) {
      print('Error loading flashcards for $topicId: $e');
      return [];
    }
  }

  /// ✅ Tải quizzes cho topic cụ thể
  Future<List<Quiz>> loadQuizzesForTopic(String topicId) async {
    try {
      // Map topicId sang tên file
      final Map<String, String> fileMap = {
        'animals': 'data/quizzes/animals_quizzes.json',
        'fruits': 'data/quizzes/fruits_quizzes.json',
        'colors': 'data/quizzes/colors_quizzes.json',
        'shapes': 'data/quizzes/shapes_quizzes.json',
        'vehicles': 'data/quizzes/vehicles_quizzes.json',
        'alphabet': 'data/quizzes/alphabet_quizzes. json',
      };

      final filePath = fileMap[topicId] ?? 'data/quizzes/animals_quizzes.json';
      final jsonString = await rootBundle.loadString(filePath);
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      final quizzes = (jsonData['quizzes'] as List)
          .map((item) => Quiz.fromJson(item as Map<String, dynamic>))
          .toList();

      return quizzes;
    } catch (e) {
      print('Error loading quizzes for $topicId: $e');
      return [];
    }
  }

  /// ✅ Tải tất cả flashcards
  Future<List<Flashcard>> loadAllFlashcards() async {
    try {
      final topics = await loadTopics();
      final allFlashcards = <Flashcard>[];

      for (final topic in topics) {
        final flashcards = await loadFlashcardsForTopic(topic.id);
        allFlashcards.addAll(flashcards);
      }

      return allFlashcards;
    } catch (e) {
      print('Error loading all flashcards: $e');
      return [];
    }
  }

  /// ✅ Tải tất cả quizzes
  Future<List<Quiz>> loadAllQuizzes() async {
    try {
      final topics = await loadTopics();
      final allQuizzes = <Quiz>[];

      for (final topic in topics) {
        final quizzes = await loadQuizzesForTopic(topic.id);
        allQuizzes.addAll(quizzes);
      }

      return allQuizzes;
    } catch (e) {
      print('Error loading all quizzes: $e');
      return [];
    }
  }
}
