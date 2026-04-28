import 'package:flutter/material.dart';

/// Widget genérico para paginar cualquier tipo de elemento.
/// Recibe una función que obtiene una página de datos y un builder para cada elemento.
class Paginate<T> extends StatefulWidget {
  final Future<List<T>> Function(int page, int pageSize) fetchPage;
  final Widget Function(BuildContext, T) itemBuilder;
  final int pageSize;
  final EdgeInsetsGeometry? padding;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final bool Function(int currentPage, List<T> lastPageItems)? hasMore;

  const Paginate({
    super.key,
    required this.fetchPage,
    required this.itemBuilder,
    this.pageSize = 20,
    this.padding,
    this.loadingWidget,
    this.emptyWidget,
    this.hasMore,
  });

  @override
  State<Paginate<T>> createState() => _PaginateState<T>();
}

class _PaginateState<T> extends State<Paginate<T>> {
  final List<T> _items = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  int _lastRequestedPage = 1;
  bool _initialLoad = true;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  Future<void> _loadPage() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);
    final pageItems = await widget.fetchPage(_currentPage, widget.pageSize);
    setState(() {
      _items.addAll(pageItems);
      _isLoading = false;
      _initialLoad = false;
      _lastRequestedPage = _currentPage;
      if (widget.hasMore != null) {
        _hasMore = widget.hasMore!(_currentPage, pageItems);
      } else {
        _hasMore = pageItems.length == widget.pageSize;
      }
      if (_hasMore) _currentPage++;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _items.clear();
      _currentPage = 1;
      _hasMore = true;
      _initialLoad = true;
    });
    await _loadPage();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoad && _isLoading) {
      return widget.loadingWidget ?? const Center(child: CircularProgressIndicator());
    }
    if (_items.isEmpty) {
      return widget.emptyWidget ?? const Center(child: Text('Sin elementos'));
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: widget.padding,
        itemCount: _items.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _items.length) {
            return widget.itemBuilder(context, _items[index]);
          } else {
            // Trigger next page load (diferido para evitar setState en build)
            Future.microtask(_loadPage);
            return widget.loadingWidget ?? const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
