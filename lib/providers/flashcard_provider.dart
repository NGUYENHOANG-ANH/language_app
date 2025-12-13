import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/flashcard_model.dart';

// Flashcard list provider
final flashcardProvider =
    StateNotifierProvider.family<FlashcardNotifier, List<Flashcard>, String>(
        (ref, topicId) {
  return FlashcardNotifier(topicId);
});

class FlashcardNotifier extends StateNotifier<List<Flashcard>> {
  final String topicId;

  FlashcardNotifier(this.topicId) : super([]) {
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    // TODO: Load from JSON or API
    // For now, return empty list
    state = [];
  }

  void addFlashcard(Flashcard flashcard) {
    state = [...state, flashcard];
  }

  void updateFlashcard(String id, Flashcard flashcard) {
    state = [
      for (final fc in state)
        if (fc.id == id) flashcard else fc,
    ];
  }

  void deleteFlashcard(String id) {
    state = state.where((fc) => fc.id != id).toList();
  }
}

// Current flashcard index provider
final currentFlashcardIndexProvider = StateProvider<int>((ref) => 0);

// Flashcard review history
final flashcardHistoryProvider = StateProvider<Map<String, int>>((ref) => {});
