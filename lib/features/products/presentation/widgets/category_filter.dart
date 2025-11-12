import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store/core/constants/app_colors.dart';
import 'package:fake_store/core/constants/app_text_styles.dart';
import 'package:fake_store/features/products/presentation/bloc/product_list/product_list_bloc.dart';
import 'package:fake_store/features/products/presentation/bloc/product_list/product_list_event.dart';

/// Widget for filtering products by category
class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;

  const CategoryFilter({
    super.key,
    required this.categories,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All" chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('All'),
              selected: selectedCategory == null,
              onSelected: (selected) {
                if (selected) {
                  context.read<ProductListBloc>().add(
                    const FilterByCategory(null),
                  );
                }
              },
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              labelStyle: AppTextStyles.bodySmall.copyWith(
                color: selectedCategory == null
                    ? AppColors.textWhite
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              side: BorderSide(
                color: selectedCategory == null
                    ? AppColors.primary
                    : AppColors.border,
              ),
            ),
          ),
          // Category chips
          ...categories.map((category) {
            final isSelected = selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_formatCategoryName(category)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    context.read<ProductListBloc>().add(
                      FilterByCategory(category),
                    );
                  }
                },
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                labelStyle: AppTextStyles.bodySmall.copyWith(
                  color: isSelected
                      ? AppColors.textWhite
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Format category name to title case
  String _formatCategoryName(String category) {
    if (category.isEmpty) return category;
    return category
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }
}
