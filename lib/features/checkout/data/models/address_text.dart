// The backend regenerates CustomerAddress server-side from a fixed template
// ("المنطقة :X  القطعة :Y  الشارع :Z  ...") whenever an address is added or
// selected — it's the only field that reflects the actually-chosen address.
// The top-level region_id/RegionName/DistrictName fields are static per
// customer profile and never change per address, so they can't be trusted
// for display. This pulls the district back out of that composed string.
String? districtFromCustomerAddress(String? customerAddress) {
  if (customerAddress == null || customerAddress.isEmpty) return null;
  for (final part in customerAddress.split('  ')) {
    final colon = part.indexOf(':');
    if (colon == -1) continue;
    final label = part.substring(0, colon).trim();
    if (label == 'المنطقة') return part.substring(colon + 1).trim();
  }
  return null;
}
