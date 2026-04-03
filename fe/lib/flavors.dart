enum Flavors { production, development }

class F {
  static Flavors? appFlavor;
  static String get name => appFlavor?.name ?? '';
  static String get title {
    switch (appFlavor) {
      case Flavors.production:
        return 'Productions';
      case Flavors.development:
        return '[DEV] development';
      default:
        return 'title';
    }
  }
}
