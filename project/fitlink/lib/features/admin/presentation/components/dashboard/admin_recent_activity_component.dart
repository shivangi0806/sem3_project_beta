import 'package:fitlink/features/admin/data/model/admin_activity_log.dart';
import 'package:fitlink/features/admin/presentation/components/src/recent_activity_tile.dart';
import 'package:flutter/material.dart';

class RecentActivityComponent extends StatefulWidget {
  final List<ActivityLog> logs;
  final bool showSearch;
  final int? maxItems;

  const RecentActivityComponent({
    super.key,
    required this.logs,
    this.showSearch = true,
    this.maxItems,
  });

  @override
  State<RecentActivityComponent> createState() =>
      _RecentActivityComponentState();
}

class _RecentActivityComponentState extends State<RecentActivityComponent> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();

    final filteredLogs = widget.logs.where((log) {
      if (query.isEmpty) return true;

      return log.service.toLowerCase().contains(query) ||
          log.action.toLowerCase().contains(query) ||
          log.actor.toLowerCase().contains(query) ||
          log.details.toLowerCase().contains(query);
    }).toList();

    final visibleLogs = widget.maxItems == null
        ? filteredLogs
        : filteredLogs.take(widget.maxItems!).toList();

    if (widget.showSearch) {
      return Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search activity, service, or user',
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white60),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.close, color: Colors.white60),
                    ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.lightBlueAccent),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(child: _buildLogList(visibleLogs)),
        ],
      );
    }

    return _buildLogList(visibleLogs);
  }

  Widget _buildLogList(List<ActivityLog> logs) {
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _query.isEmpty ? Icons.inbox_outlined : Icons.search_off,
              color: Colors.white38,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              _query.isEmpty
                  ? 'No activity has been recorded yet.'
                  : 'No activity matches your search.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => ActivityLogTile(log: logs[index]),
    );
  }
}
