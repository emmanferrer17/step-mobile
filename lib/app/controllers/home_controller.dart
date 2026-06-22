import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../data/services/api_service.dart';
import 'auth_controller.dart';

// [MVC - CONTROLLER]
// HomeController manages the state and logic for the Home screen items.
class HomeController extends ChangeNotifier {
  final AuthController _authController;
  final ApiService _apiService = ApiService();

  HomeController(this._authController);

  /// Syncs all item images and returns a map with 'error' and 'all_images' on success.
  Future<Map<String, dynamic>> syncItemImages(int itemId, List<String> existingImages, List<File> newImages) async {
    final token = _authController.token;
    if (token == null) return {'error': 'Not authenticated'};

    final result = await _apiService.syncItemImages(itemId, existingImages, newImages, token);
    
    if (result['status'] == 'success') {
      // The backend now returns the full list of images from the new table
      return {'error': null, 'all_images': result['data']?['item_images'] ?? result['data']?['all_images']};
    } else {
      return {'error': result['message'] ?? 'Failed to sync item images.'};
    }
  }

  // Deletes an item image and returns a map with 'error' and 'all_images' on success.
  Future<Map<String, dynamic>> deleteItemImage(int itemId, String imagePath) async {
    final token = _authController.token;
    if (token == null) return {'error': 'Not authenticated'};

    final result = await _apiService.deleteItemImage(itemId, imagePath, token);

    if (result['status'] == 'success') {
      return {'error': null, 'all_images': result['data']?['item_images'] ?? result['data']?['all_images']};
    } else {
      return {'error': result['message'] ?? 'Failed to delete item image.'};
    }
  }

  // Uploads a new item image and returns a map with 'error' and 'all_images' on success.
  Future<Map<String, dynamic>> updateItemImage(int itemId, File imageFile) async {
    final token = _authController.token;
    if (token == null) return {'error': 'Not authenticated'};

    final result = await _apiService.updateItemImage(itemId, imageFile, token);
    
    if (result['status'] == 'success') {
      return {'error': null, 'all_images': result['data']?['item_images'] ?? result['data']?['all_images']};
    } else {
      return {'error': result['message'] ?? 'Failed to upload item image.'};
    }
  }

  /// Updates item location and returns a map with 'error' and 'data' on success.
  Future<Map<String, dynamic>> updateItemLocation(int itemId, String? building, String? roomNo) async {
    final token = _authController.token;
    if (token == null) return {'error': 'Not authenticated'};

    final result = await _apiService.updateItemLocation(itemId, building, roomNo, token);

    if (result['status'] == 'success') {
      return {'error': null, 'data': result['data']?['item']};
    } else {
      return {'error': result['message'] ?? 'Failed to update item location.'};
    }
  }

  /// Fetches all MR items for the logged-in user.
  Future<Map<String, dynamic>> getMrItems() async {
    final token = _authController.token;
    if (token == null) return {'error': 'Not authenticated'};

    final result = await _apiService.getMrItems(token);
    
    if (result['status'] == 'success') {
      return {'error': null, 'items': result['data']?['items'] ?? []};
    } else {
      return {'error': result['message'] ?? 'Failed to fetch items.'};
    }
  }
}
