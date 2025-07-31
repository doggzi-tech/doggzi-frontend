// custom_search_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller for managing search state
class CustomSearchController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  // Observable variables
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isFocused = false.obs;
  final RxList<String> searchHistory = <String>[].obs;
  final RxList<String> suggestions = <String>[].obs;
  final RxBool showDropdown = false.obs;

  // Callback functions
  Function(String)? onSearchChanged;
  Function(String)? onSearchSubmitted;
  VoidCallback? onClearPressed;
  VoidCallback? onFilterPressed;

  @override
  void onInit() {
    super.onInit();

    // Listen to text changes
    textController.addListener(() {
      searchQuery.value = textController.text;
      if (onSearchChanged != null) {
        onSearchChanged!(textController.text);
      }
    });

    // Listen to focus changes
    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;
      if (focusNode.hasFocus && searchHistory.isNotEmpty) {
        updateSuggestions(searchHistory);
        showDropdown.value = true;
      } else {
        showDropdown.value = false;
      }
    });
  }

  void setCallbacks({
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    VoidCallback? onClear,
    VoidCallback? onFilter,
  }) {
    onSearchChanged = onChanged;
    onSearchSubmitted = onSubmitted;
    onClearPressed = onClear;
    onFilterPressed = onFilter;
  }

  void search(String query) {
    if (query.isNotEmpty) {
      isLoading.value = true;
      showDropdown.value = false;

      // Add to search history
      if (!searchHistory.contains(query)) {
        searchHistory.insert(0, query);
        if (searchHistory.length > 10) {
          searchHistory.removeLast();
        }
      }

      // Simulate API call
      Future.delayed(const Duration(milliseconds: 800), () {
        isLoading.value = false;
        if (onSearchSubmitted != null) {
          onSearchSubmitted!(query);
        }
      });
    }
  }

  void clearSearch() {
    textController.clear();
    searchQuery.value = '';
    suggestions.clear();
    showDropdown.value = false;
    if (onClearPressed != null) {
      onClearPressed!();
    }
  }

  void updateSuggestions(List<String> newSuggestions) {
    suggestions.value = newSuggestions;
  }

  void selectSuggestion(String suggestion) {
    textController.text = suggestion;
    searchQuery.value = suggestion;
    showDropdown.value = false;
    search(suggestion);
  }

  void openFilter() {
    if (onFilterPressed != null) {
      onFilterPressed!();
    }
  }

  @override
  void onClose() {
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
