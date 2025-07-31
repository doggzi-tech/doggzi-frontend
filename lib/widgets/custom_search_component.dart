// Main Search Widget
import 'package:doggzi/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/search_controller.dart';

class CustomSearchWidget extends StatelessWidget {
  final String hintText;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool showSearchHistory;
  final bool showSuggestions;
  final bool showFilterButton;
  final List<String>? initialSuggestions;
  final Function(String)? onSearchChanged;
  final Function(String)? onSearchSubmitted;
  final VoidCallback? onClearPressed;
  final VoidCallback? onFilterPressed;
  final Widget? customFilterIcon;
  final Widget? customSuffixIcon;
  final bool enabled;
  final double? height;

  const CustomSearchWidget({
    Key? key,
    this.hintText = 'Search Food, Restaurants etc.',
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.showSearchHistory = true,
    this.showSuggestions = true,
    this.showFilterButton = true,
    this.initialSuggestions,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onClearPressed,
    this.onFilterPressed,
    this.customFilterIcon,
    this.customSuffixIcon,
    this.enabled = true,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomSearchController controller = Get.put(CustomSearchController());

    // Set callbacks
    controller.setCallbacks(
      onChanged: onSearchChanged,
      onSubmitted: onSearchSubmitted,
      onClear: onClearPressed,
      onFilter: onFilterPressed,
    );

    // Set initial suggestions
    if (initialSuggestions != null) {
      controller.updateSuggestions(initialSuggestions!);
    }

    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar container
          Row(
            children: [
              // Main search bar
              Expanded(
                child: _buildSearchContainer(controller, context),
              ),
            ],
          ),

          // Suggestions dropdown
          Obx(() => _buildSuggestionsDropdown(controller, context)),
        ],
      ),
    );
  }

  Widget _buildSearchContainer(
      CustomSearchController controller, BuildContext context) {
    return Obx(() => Container(
          height: height ?? 50.h,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey[100],
            borderRadius: BorderRadius.circular(borderRadius ?? 25.r),
            border: Border.all(
              color: controller.isFocused.value
                  ? (borderColor ?? Theme.of(context).primaryColor)
                  : Colors.transparent,
              width: controller.isFocused.value ? 2.w : 0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(controller.isFocused.value ? 0.1 : 0.05),
                blurRadius: controller.isFocused.value ? 15.r : 8.r,
                offset: Offset(0, controller.isFocused.value ? 4.h : 2.h),
              ),
            ],
          ),
          child: Row(
            children: [
              // Search icon
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 12.w),
                child: Icon(
                  Icons.search,
                  color: controller.isFocused.value
                      ? (borderColor ?? Theme.of(context).primaryColor)
                      : (iconColor ?? Colors.grey[600]),
                  size: 20.sp,
                ),
              ),

              // Search input field
              Expanded(
                child: TextField(
                  controller: controller.textController,
                  focusNode: controller.focusNode,
                  enabled: enabled,
                  style: TextStyle(
                    color: textColor ?? Colors.black87,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: hintColor ?? Colors.grey[500],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (value) {
                    controller.search(value);
                  },
                  onTap: () {
                    if (showSearchHistory &&
                        controller.searchHistory.isNotEmpty) {
                      controller.updateSuggestions(controller.searchHistory);
                      controller.showDropdown.value = true;
                    }
                  },
                ),
              ),

              // Trailing icons (loading/clear)
              _buildTrailingIcons(controller, context),
              // Filter button
              if (showFilterButton) ...[
                SizedBox(width: 12.w),
                _buildFilterButton(controller, context),
              ],
            ],
          ),
        ));
  }

  Widget _buildTrailingIcons(
      CustomSearchController controller, BuildContext context) {
    return Obx(() => Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.isLoading.value) ...[
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ] else if (controller.searchQuery.value.isNotEmpty) ...[
                GestureDetector(
                  onTap: () => controller.clearSearch(),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    child: customSuffixIcon ??
                        Icon(
                          Icons.clear,
                          color: iconColor ?? Colors.grey[600],
                          size: 20.sp,
                        ),
                  ),
                ),
              ],
            ],
          ),
        ));
  }

  Widget _buildFilterButton(
      CustomSearchController controller, BuildContext context) {
    return GestureDetector(
      onTap: () => controller.openFilter(),
      child: Container(
        height: height ?? 50.h,
        width: 50.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 25.r),
        ),
        child: Center(
          child: customFilterIcon ??
              Icon(
                Icons.filter_list_sharp,
                color: iconColor ?? OldAppColors.primaryOrange,
                size: 25.sp,
              ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsDropdown(
      CustomSearchController controller, BuildContext context) {
    if (!showSuggestions && !showSearchHistory) {
      return const SizedBox.shrink();
    }

    if (!controller.showDropdown.value || controller.suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: controller.suggestions.length > 5
            ? 5
            : controller.suggestions.length,
        separatorBuilder: (context, index) => Divider(
          height: 1.h,
          color: Colors.grey[200],
          indent: 16.w,
          endIndent: 16.w,
        ),
        itemBuilder: (context, index) {
          final suggestion = controller.suggestions[index];
          final isFromHistory = controller.searchHistory.contains(suggestion);

          return ListTile(
            dense: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            leading: Icon(
              isFromHistory ? Icons.history : Icons.search,
              color: Colors.grey[600],
              size: 18.sp,
            ),
            title: Text(
              suggestion,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            trailing: Icon(
              Icons.call_made,
              color: Colors.grey[400],
              size: 16.sp,
            ),
            onTap: () => controller.selectSuggestion(suggestion),
          );
        },
      ),
    );
  }
}
