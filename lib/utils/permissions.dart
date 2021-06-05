import 'package:flutter/services.dart';
import 'package:dmman/constants/msgs_to_user.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> cameraAndMicrophonePermissionsGranted() async {
    PermissionStatus cameraPermissionStatus = await _getCameraPermission();
    PermissionStatus microphonePermissionStatus =
        await _getMicrophonePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(
          cameraPermissionStatus, microphonePermissionStatus);
      return false;
    }
  }

  static Future<PermissionStatus> _getCameraPermission() async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.camera]);
      return permissionStatus[PermissionGroup.camera] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  static Future<PermissionStatus> _getMicrophonePermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.microphone]);
      return permissionStatus[PermissionGroup.microphone] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  static void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: PER_DENIED, message: ACCESS_CAMERA, details: null);
    } else if (cameraPermissionStatus == PermissionStatus.disabled &&
        microphonePermissionStatus == PermissionStatus.disabled) {
      throw new PlatformException(
          code: PER_DISABLED, message: LOC_DATA, details: null);
    }
  }
}
