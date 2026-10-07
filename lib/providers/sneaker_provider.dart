// ============================================================================
// [START] FILE: sneaker_provider.dart
// ============================================================================

// ============================================================================
// [START] IMPORTS
// ============================================================================
import 'dart:async';
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/notification_item.dart';
import '../models/sneaker.dart';
import '../services/firebase_service.dart';
import 'notification_provider.dart';
// ============================================================================
// [END] IMPORTS
// ============================================================================

// ============================================================================
// [START] SNEAKER PROVIDER
// ============================================================================
class SneakerProvider extends ChangeNotifier {
  final List<Sneaker> _sneakers = List.from(MockData.sneakers);
  StreamSubscription<List<Sneaker>>? _sneakersSubscription;
  bool _isCloudSyncActive = false;

  bool get isCloudSyncActive => _isCloudSyncActive;
  List<Sneaker> get sneakers => List.unmodifiable(_sneakers);

  SneakerProvider() {
    _initCloudSync();
  }

  void _initCloudSync() {
    // 1. Seed cloud catalog if empty on first launch
    FirebaseService.instance.seedInitialSneakersIfEmpty(MockData.sneakers);

    // 2. Listen to real-time updates from Cloud Firestore
    _sneakersSubscription = FirebaseService.instance.getSneakersStream().listen(
      (cloudList) {
        if (cloudList.isNotEmpty) {
          _sneakers
            ..clear()
            ..addAll(cloudList);
          _isCloudSyncActive = true;
          notifyListeners();
        }
      },
      onError: (e) {
        // Graceful fallback to resilient offline cache
        _isCloudSyncActive = false;
      },
    );
  }

  @override
  void dispose() {
    _sneakersSubscription?.cancel();
    super.dispose();
  }

  int get totalSneakersCount => _sneakers.length;

  int get trendingCount => _sneakers.where((s) => s.isTrending).length;

  // Category counts map
  Map<String, int> get categoryCounts {
    final Map<String, int> counts = {};
    for (final s in _sneakers) {
      counts[s.category] = (counts[s.category] ?? 0) + 1;
    }
    return counts;
  }

  // Brand counts map
  Map<String, int> get brandCounts {
    final Map<String, int> counts = {};
    for (final s in _sneakers) {
      counts[s.brand] = (counts[s.brand] ?? 0) + 1;
    }
    return counts;
  }

  // --------------------------------------------------------------------------
  // [START] CRUD OPERATIONS
  // --------------------------------------------------------------------------
  void addSneaker(Sneaker sneaker) {
    _sneakers.insert(0, sneaker);
    // Also keep MockData in sync
    MockData.sneakers.insert(0, sneaker);
    notifyListeners();
    // Cloud Firestore Sync (Non-blocking)
    FirebaseService.instance.saveSneakerToCloud(sneaker);

    NotificationProvider.send(
      title: 'New Drop Alert! 🔥',
      message: '${sneaker.name} by ${sneaker.brand} has just dropped in the store!',
      type: NotificationType.newArrivals,
    );
  }

  void updateSneaker(Sneaker updated) {
    final index = _sneakers.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _sneakers[index] = updated;
      final mockIndex = MockData.sneakers.indexWhere((s) => s.id == updated.id);
      if (mockIndex != -1) {
        MockData.sneakers[mockIndex] = updated;
      }
      notifyListeners();
      // Cloud Firestore Sync (Non-blocking)
      FirebaseService.instance.saveSneakerToCloud(updated);
    }
  }

  void updatePrice(String sneakerId, double newPrice) {
    final index = _sneakers.indexWhere((s) => s.id == sneakerId);
    if (index != -1) {
      final old = _sneakers[index];
      final updated = Sneaker(
        id: old.id,
        name: old.name,
        brand: old.brand,
        category: old.category,
        price: newPrice,
        rating: old.rating,
        reviewCount: old.reviewCount,
        image: old.image,
        galleryImages: old.galleryImages,
        angleLabels: old.angleLabels,
        specs: old.specs,
        description: old.description,
        sizes: old.sizes,
        isTrending: old.isTrending,
      );
      _sneakers[index] = updated;
      final mockIndex = MockData.sneakers.indexWhere((s) => s.id == sneakerId);
      if (mockIndex != -1) {
        MockData.sneakers[mockIndex] = updated;
      }
      notifyListeners();
      // Cloud Firestore Sync (Non-blocking)
      FirebaseService.instance.updateSneakerPriceInCloud(sneakerId, newPrice);

      NotificationProvider.send(
        title: 'Price Drop Alert! 🏷️',
        message: '${old.name} is now available at ₹${newPrice.toStringAsFixed(0)}!',
        type: NotificationType.priceDrop,
      );
    }
  }

  void toggleTrending(String sneakerId) {
    final index = _sneakers.indexWhere((s) => s.id == sneakerId);
    if (index != -1) {
      final old = _sneakers[index];
      final updated = Sneaker(
        id: old.id,
        name: old.name,
        brand: old.brand,
        category: old.category,
        price: old.price,
        rating: old.rating,
        reviewCount: old.reviewCount,
        image: old.image,
        galleryImages: old.galleryImages,
        angleLabels: old.angleLabels,
        specs: old.specs,
        description: old.description,
        sizes: old.sizes,
        isTrending: !old.isTrending,
      );
      _sneakers[index] = updated;
      final mockIndex = MockData.sneakers.indexWhere((s) => s.id == sneakerId);
      if (mockIndex != -1) {
        MockData.sneakers[mockIndex] = updated;
      }
      notifyListeners();
      // Cloud Firestore Sync (Non-blocking)
      FirebaseService.instance.saveSneakerToCloud(updated);
    }
  }

  void deleteSneaker(String sneakerId) {
    _sneakers.removeWhere((s) => s.id == sneakerId);
    MockData.sneakers.removeWhere((s) => s.id == sneakerId);
    notifyListeners();
    // Cloud Firestore Sync (Non-blocking)
    FirebaseService.instance.deleteSneakerFromCloud(sneakerId);
  }
  // --------------------------------------------------------------------------
  // [END] CRUD OPERATIONS
  // --------------------------------------------------------------------------
}
// ============================================================================
// [END] SNEAKER PROVIDER
// ============================================================================

// ============================================================================
// [END] FILE: sneaker_provider.dart
// ============================================================================
