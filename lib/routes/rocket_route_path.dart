class RocketRoutePath {
  final int? id;
  final bool? isUnknown;

  RocketRoutePath.details(this.id) : isUnknown = false;

  RocketRoutePath.home()
      : id = null,
        isUnknown = false;

  RocketRoutePath.unknown()
      : id = null,
        isUnknown = true;

  bool get isDetailsPage => id != null;

  bool get isHomePage => id == null;
}
