import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/data/models/post_category_model.dart';

class PostCategoryRepository {
  /// Get all active post categories
  Future<List<PostCategoryModel>> getAllCategories() async {
    final data = await supabase
        .from('post_categories')
        .select()
        .eq('is_active', true)
        .order('sort_order');

    return (data as List)
        .map((json) => PostCategoryModel.fromJson(json))
        .toList();
  }

  /// Get a specific category by ID
  Future<PostCategoryModel> getCategoryById(String categoryId) async {
    final data = await supabase
        .from('post_categories')
        .select()
        .eq('id', categoryId)
        .single();

    return PostCategoryModel.fromJson(data);
  }

  /// Get category by name
  Future<PostCategoryModel?> getCategoryByName(String name) async {
    final data = await supabase
        .from('post_categories')
        .select()
        .eq('name', name)
        .maybeSingle();

    if (data == null) return null;
    return PostCategoryModel.fromJson(data);
  }

  /// Create a new category (Admin only)
  Future<PostCategoryModel> createCategory({
    required String name,
    String? nameMn,
    String? description,
    String? iconName,
    String? colorHex,
    int sortOrder = 0,
  }) async {
    final data = await supabase
        .from('post_categories')
        .insert({
          'name': name,
          'name_mn': nameMn,
          'description': description,
          'icon_name': iconName,
          'color_hex': colorHex,
          'sort_order': sortOrder,
          'is_active': true,
        })
        .select()
        .single();

    return PostCategoryModel.fromJson(data);
  }

  /// Update a category (Admin only)
  Future<PostCategoryModel> updateCategory({
    required String categoryId,
    String? name,
    String? nameMn,
    String? description,
    String? iconName,
    String? colorHex,
    int? sortOrder,
    bool? isActive,
  }) async {
    final updateData = <String, dynamic>{};
    if (name != null) updateData['name'] = name;
    if (nameMn != null) updateData['name_mn'] = nameMn;
    if (description != null) updateData['description'] = description;
    if (iconName != null) updateData['icon_name'] = iconName;
    if (colorHex != null) updateData['color_hex'] = colorHex;
    if (sortOrder != null) updateData['sort_order'] = sortOrder;
    if (isActive != null) updateData['is_active'] = isActive;

    final data = await supabase
        .from('post_categories')
        .update(updateData)
        .eq('id', categoryId)
        .select()
        .single();

    return PostCategoryModel.fromJson(data);
  }

  /// Delete a category (Admin only)
  Future<void> deleteCategory(String categoryId) async {
    await supabase.from('post_categories').delete().eq('id', categoryId);
  }

  /// Reorder categories (Admin only)
  Future<void> reorderCategories(List<Map<String, dynamic>> categoryOrders) async {
    // categoryOrders should be [{'id': 'uuid', 'sort_order': 1}, ...]
    for (var order in categoryOrders) {
      await supabase
          .from('post_categories')
          .update({'sort_order': order['sort_order']})
          .eq('id', order['id']);
    }
  }
}
