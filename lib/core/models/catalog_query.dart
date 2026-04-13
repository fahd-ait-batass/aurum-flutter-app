class CatalogQuery {
  const CatalogQuery({this.searchText = '', this.category});

  final String searchText;
  final String? category;

  bool get hasSearchText => searchText.trim().isNotEmpty;
  bool get hasCategory => (category ?? '').trim().isNotEmpty;
}
