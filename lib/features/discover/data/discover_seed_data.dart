class DiscoverFilter {
  const DiscoverFilter({required this.label, this.isActive = false});

  final String label;
  final bool isActive;
}

const List<DiscoverFilter> discoverFilters = <DiscoverFilter>[
  DiscoverFilter(label: 'Open now', isActive: true),
  DiscoverFilter(label: 'Fine dining'),
  DiscoverFilter(label: 'Rooftop'),
  DiscoverFilter(label: 'Chef tasting'),
  DiscoverFilter(label: 'Desserts'),
];
