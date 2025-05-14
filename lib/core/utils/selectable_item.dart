class SelectableItem<T> {
  final T data;
  final String title;
  final String? subtitle;

  const SelectableItem({
    required this.data,
    required this.title,
    this.subtitle,
  });
}
