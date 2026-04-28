import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _ViewModelProviderType { WithoutConsumer, WithConsumer }

/// A widget that provides base functionality for the Mvvm style provider architecture by FilledStacks.
class ViewModelProvider<T extends ChangeNotifier> extends StatefulWidget {
  final Widget? staticChild;
  final Function(T) onModelReady;
  final Widget Function(BuildContext, T, Widget?) builder;
  final T viewModel;
  final _ViewModelProviderType providerType;

  ViewModelProvider.withoutConsumer({
    required this.builder,
    required this.viewModel,
    required this.onModelReady,
  })  : providerType = _ViewModelProviderType.WithoutConsumer,
        staticChild = const SizedBox.shrink();

  ViewModelProvider.withConsumer({
    required this.viewModel,
    required this.builder,
    this.staticChild,
    required this.onModelReady,
  }) : providerType = _ViewModelProviderType.WithConsumer;

  @override
  _ViewModelProviderState<T> createState() => _ViewModelProviderState<T>();
}

class _ViewModelProviderState<T extends ChangeNotifier>
    extends State<ViewModelProvider<T>> {
  late T _model;

  @override
  void initState() {
    super.initState();
    _model = widget.viewModel;

    if (widget.onModelReady != null) {
      widget.onModelReady(_model);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.providerType == _ViewModelProviderType.WithoutConsumer) {
      return ChangeNotifierProvider(
        create: (context) => _model,
        child: widget.builder(context, _model, null),
      );
    }

    return ChangeNotifierProvider(
      create: (context) => _model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.staticChild,
      ),
    );
  }
}