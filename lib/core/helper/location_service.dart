// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';

// class LocationService {
//   Future<LatLng?> getCurrentLocation() async {
//     try {
//       if (!await Geolocator.isLocationServiceEnabled()) return null;
//       var permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         return null;
//       }
//       final pos = await Geolocator.getCurrentPosition();
//       return LatLng(pos.latitude, pos.longitude);
//     } catch (_) {
//       // return null;
//     }
//   }

//   Future<Map<String, String?>> getAddressFromCoordinates(
//     LatLng location, {
//     required String localeIdentifier,
//   }) async {
//     try {
//       await setLocaleIdentifier(localeIdentifier);
//       final placemarks = await placemarkFromCoordinates(
//         location.latitude,
//         location.longitude,
//       );
//       if (placemarks.isEmpty) return {};
//       final p = placemarks.first;
//       final districtName =
//           (p.subAdministrativeArea?.isNotEmpty ?? false)
//               ? p.subAdministrativeArea
//               : p.subLocality;
//       final regionName = p.administrativeArea;
//       final streetName = p.street;
//       final parts = <String?>[
//         p.name,
//         p.street,
//         p.subLocality,
//         p.locality,
//         p.administrativeArea,
//         p.country,
//       ].where((s) => s != null && s.isNotEmpty).toList();
//       return {
//         'fullAddress': parts.isEmpty ? null : parts.join(', '),
//         'districtName': districtName,
//         'regionName': regionName,
//         'streetName': streetName,
//       };
//     } catch (_) {
//       return {};
//     }
//   }
// }
