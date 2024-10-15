// ignore_for_file: unnecessary_getters_setters

part of mapbox_gl_platform_interface;

typedef OnPlatformViewCreatedCallback = void Function(int);

abstract class MapboxGlPlatform {
  /// The default instance of [MapboxGlPlatform] to use.
  ///
  /// Defaults to [MethodChannelMapboxGl].
  ///
  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [MapboxGlPlatform] when they register themselves.
  static MapboxGlPlatform Function() createInstance =
      () => MethodChannelMapboxGl();

  final onInfoWindowTappedPlatform = ArgumentCallbacks<String>();

  final onFeatureTappedPlatform = ArgumentCallbacks<Map<String, dynamic>>();

  final onFeatureDraggedPlatform = ArgumentCallbacks<Map<String, dynamic>>();

  final onCameraMoveStartedPlatform = ArgumentCallbacks<void>();

  final onCameraMovePlatform = ArgumentCallbacks<CameraPosition>();

  final onCameraIdlePlatform = ArgumentCallbacks<CameraPosition?>();

  final onMapStyleLoadedPlatform = ArgumentCallbacks<void>();

  final onMapClickPlatform = ArgumentCallbacks<Map<String, dynamic>>();

  final onMapLongClickPlatform = ArgumentCallbacks<Map<String, dynamic>>();

  final ArgumentCallbacks<void> onAttributionClickPlatform =
      ArgumentCallbacks<void>();

  final ArgumentCallbacks<MyLocationTrackingMode>
      onCameraTrackingChangedPlatform =
      ArgumentCallbacks<MyLocationTrackingMode>();

  final onCameraTrackingDismissedPlatform = ArgumentCallbacks<void>();

  final onMapIdlePlatform = ArgumentCallbacks<void>();

  final onUserLocationUpdatedPlatform = ArgumentCallbacks<UserLocation>();

  Future<void> initPlatform(int id);
  Widget buildView(
      Map<String, dynamic> creationParams,
      OnPlatformViewCreatedCallback onPlatformViewCreated,
      Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers);
  Future<CameraPosition?> updateMapOptions(Map<String, dynamic> optionsUpdate);
  Future<bool?> animateCamera(CameraUpdate cameraUpdate);
  Future<bool?> moveCamera(CameraUpdate cameraUpdate);
  Future<void> updateMyLocationTrackingMode(
      MyLocationTrackingMode myLocationTrackingMode);

  Future<void> matchMapLanguageWithDeviceDefault();

  Future<void> updateContentInsets(EdgeInsets insets, bool animated);
  Future<void> setMapLanguage(String language);
  Future<void> setTelemetryEnabled(bool enabled);

  Future<bool> getTelemetryEnabled();
  Future<List> queryRenderedFeatures(
      Point<double> point, List<String> layerIds, List<Object>? filter);

  Future<List> queryRenderedFeaturesInRect(
      Rect rect, List<String> layerIds, String? filter);
  Future invalidateAmbientCache();
  Future<LatLng?> requestMyLocationLatLng();

  Future<LatLngBounds> getVisibleRegion();

  Future<void> addImage(String name, Uint8List bytes, [bool sdf = false]);

  Future<void> addImageSource(
      String imageSourceId, Uint8List bytes, LatLngQuad coordinates);

  Future<void> addLayer(String imageLayerId, String imageSourceId);
  Future<void> addLayerBelow(
      String imageLayerId, String imageSourceId, String belowLayerId);

  Future<void> removeLayer(String imageLayerId);

  Future<Point> toScreenLocation(LatLng latLng);

  Future<List<Point>> toScreenLocationBatch(Iterable<LatLng> latLngs);

  Future<LatLng> toLatLng(Point screenLocation);

  Future<double> getMetersPerPixelAtLatitude(double latitude);

  Future<void> addGeoJsonSource(String sourceId, Map<String, dynamic> geojson,
      {String? promoteId});

  Future<void> setGeoJsonSource(String sourceId, Map<String, dynamic> geojson);

  Future<void> setFeatureForGeoJsonSource(
      String sourceId, Map<String, dynamic> geojsonFeature);

  Future<void> removeSource(String sourceId);

  Future<void> addSymbolLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId,
      String? sourceLayer,
      required bool enableInteraction});

  Future<void> addLineLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId,
      String? sourceLayer,
      required bool enableInteraction});

  Future<void> addCircleLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId,
      String? sourceLayer,
      required bool enableInteraction});

  Future<void> addFillLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId,
      String? sourceLayer,
      required bool enableInteraction});

  Future<void> addRasterLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId, String? sourceLayer});  

  Future<void> addHillshadeLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId, String? sourceLayer});

  Future<void> addSource(String sourceId, SourceProperties properties);

  //* Custom implemented methods
  Future<Map<String, String>> getCustomHeaders(); ////=> won't migrate
  Future<void> setCustomHeaders(Map<String, String> headers, List<String> filter); //?=> setHttpHeaders, needs testing with changing access token
  Future<Map<String, String>> getLastUsedCustomHeaders(); ////=> won't migrate
  Future<void> setMaximumFps(int value); //*=> awaiting PR
  Future<void> forceOnlineMode(); //?=> setOffline, needs testing 
  Future<void> animateCameraWithDuration(CameraUpdate cameraUpdate, int duration); //=> animateCamera with duration as parameter
  Future<CameraPosition?> queryCameraPosition(); //?=> updateMapOptions, needs testing if it's fast enough
  Future<bool> setLayerVisibility(String layerId, bool isVisible); //*=> awaiting PR
  Future<bool> setLayerFilter(String layerId, String filter); //*=> awaiting PR
  Future<bool> editGeoJsonSource(String id, String data); //?=> setGeoJsonSource, needs testing if it works
  Future<bool> editGeoJsonUrl(String id, String url); ////=> won't migrate
  Future<String?> getStyle(); //! needs to be migrated
  Future<Point<double>> toScreenCoordinates(LatLng point); //=> toScreenLocation
  Future<List> querySourceFeatures(String sourceId, List<String> sourceLayers, {String? filter}); ////=> won't migrate

  @mustCallSuper
  void dispose() {
    // clear all callbacks to avoid cyclic refs
    onInfoWindowTappedPlatform.clear();
    onFeatureTappedPlatform.clear();
    onFeatureDraggedPlatform.clear();
    onCameraMoveStartedPlatform.clear();
    onCameraMovePlatform.clear();
    onCameraIdlePlatform.clear();
    onMapStyleLoadedPlatform.clear();

    onMapClickPlatform.clear();
    onMapLongClickPlatform.clear();
    onAttributionClickPlatform.clear();
    onCameraTrackingChangedPlatform.clear();
    onCameraTrackingDismissedPlatform.clear();
    onMapIdlePlatform.clear();
    onUserLocationUpdatedPlatform.clear();
  }
}
