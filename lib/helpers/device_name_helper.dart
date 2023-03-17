class DeviceNameHelper {
  static String SplitDeivceName(String deviceName) {
    return deviceName.replaceAllMapped(RegExp("(\\B[A-Z])"), (m) => ' ${m[1]}');
  }
}
