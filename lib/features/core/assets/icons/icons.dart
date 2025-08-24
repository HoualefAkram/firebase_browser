class AppIcons {
  static const iconsFolder = "assets/icons";

  static String _getIconByName(String name) => "$iconsFolder/$name";

  static final String firebaseIconMono = _getIconByName(
    "firebase_icon_mono.png",
  );

  static final String firebaseIconFull = _getIconByName(
    "firebase_icon_full.png",
  );

  static final String firebaseHorizontalMono = _getIconByName(
    "firebase_horizontal_mono.png",
  );

  static final String firebaseHorizontalFull = _getIconByName(
    "firebase_horizontal_full.png",
  );

  static final String firebaseVerticalMono = _getIconByName(
    "firebase_vertical_mono.png",
  );

  static final String firebaseVerticalFull = _getIconByName(
    "firebase_vertical_full.png",
  );
}
