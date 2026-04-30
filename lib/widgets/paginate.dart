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
  final Widget? header;
  final Widget Function(Object error, Future<void> Function() retry)?
      errorBuilder;
  final bool Function(int currentPage, List<T> lastPageItems)? hasMore;

  const Paginate({
    super.key,
    required this.fetchPage,
    required this.itemBuilder,
    this.pageSize = 20,
    this.padding,
    this.loadingWidget,
    this.emptyWidget,
    this.header,
    this.errorBuilder,
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
  bool _initialLoad = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  Future<void> _loadPage() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final pageItems = await widget.fetchPage(_currentPage, widget.pageSize);
      setState(() {
        _items.addAll(pageItems);
        _isLoading = false;
        _initialLoad = false;
        if (widget.hasMore != null) {
          _hasMore = widget.hasMore!(_currentPage, pageItems);
        } else {
          _hasMore = pageItems.length == widget.pageSize;
        }
        if (_hasMore) _currentPage++;
      });
    } catch (e) {
      setState(() {
        _error = e;
        _isLoading = false;
        _initialLoad = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _items.clear();
      _currentPage = 1;
      _hasMore = true;
      _initialLoad = true;
      _error = null;
    });
    await _loadPage();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoad && _isLoading) {
      return _buildRefreshableState(
        widget.loadingWidget ?? const CircularProgressIndicator(),
      );
    }
    if (_error != null && _items.isEmpty) {
      return _buildRefreshableState(
        widget.errorBuilder?.call(_error!, _refresh) ??
            Text(_error!.toString()),
      );
    }
    if (_items.isEmpty) {
      return _buildRefreshableState(
        widget.emptyWidget ?? const Text('Sin elementos'),
      );
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: widget.padding,
        itemCount: _items.length + (_hasMore ? 1 : 0) + _headerCount,
        itemBuilder: (context, index) {
          if (widget.header != null && index == 0) {
            return widget.header!;
          }

          final itemIndex = index - _headerCount;
          if (itemIndex < _items.length) {
            return widget.itemBuilder(context, _items[itemIndex]);
          } else if (_error != null) {
            return widget.errorBuilder?.call(_error!, _loadPage) ??
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text(_error!.toString())),
                );
          } else {
            // Trigger next page load (diferido para evitar setState en build)
            Future.microtask(_loadPage);
            return widget.loadingWidget ??
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                );
          }
        },
      ),
    );
  }

  int get _headerCount => widget.header == null ? 0 : 1;

  Widget _buildRefreshableState(Widget child) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (widget.header != null) SliverToBoxAdapter(child: widget.header!),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: child),
          ),
        ],
      ),
    );
  }
}
