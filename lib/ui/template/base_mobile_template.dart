import 'package:flutter/material.dart';

class BaseMobileTemplate extends StatefulWidget {
  const BaseMobileTemplate({
    super.key,
    required this.left,
    required this.right,
    this.tabs = const [],
  });

  final Widget left;
  final Widget right;

  final List<Tab> tabs;

  @override
  State<BaseMobileTemplate> createState() => _BaseMobileTemplateState();
}

class _BaseMobileTemplateState extends State<BaseMobileTemplate>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: widget.tabs,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TabBarView(controller: _tabController, children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: widget.left,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: widget.right,
            ),
          ]),
        ),
      ],
    );
  }
}
