import 'dart:async';

import 'package:app/app/theme/app_colors.dart';
import 'package:app/core/location/location_requirement_service.dart';
import 'package:flutter/material.dart';

class LocationRequiredGate extends StatefulWidget {
  const LocationRequiredGate({
    super.key,
    required this.enabled,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  State<LocationRequiredGate> createState() => _LocationRequiredGateState();
}

class _LocationRequiredGateState extends State<LocationRequiredGate> {
  final LocationRequirementService _locationService =
      LocationRequirementService();

  Timer? _retryTimer;
  bool _isChecking = false;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _ensureLocation();
    }
  }

  @override
  void didUpdateWidget(LocationRequiredGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _ensureLocation();
    }
    if (!widget.enabled && oldWidget.enabled) {
      _retryTimer?.cancel();
      _isReady = false;
      _locationService.stop();
    }
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _locationService.stop();
    super.dispose();
  }

  Future<void> _ensureLocation() async {
    if (_isChecking || !widget.enabled) {
      return;
    }

    setState(() {
      _isChecking = true;
    });

    final ready = await _locationService.ensureLocationReady();
    if (!mounted) {
      return;
    }

    setState(() {
      _isReady = ready;
      _isChecking = false;
    });

    _retryTimer?.cancel();
    if (!ready && widget.enabled) {
      _retryTimer = Timer(const Duration(seconds: 5), _ensureLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || _isReady) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        ColoredBox(
          color: Colors.black.withValues(alpha: 0.45),
          child: Center(
            child: Container(
              width: 320,
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 42,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Cần bật vị trí GPS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.brownText,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Bạn cần bật location để sử dụng app và chỉ đường tới cửa hàng.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.mutedText, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _isChecking ? null : _ensureLocation,
                    icon: _isChecking
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.gps_fixed_rounded),
                    label: const Text('Bật vị trí'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
