import 'package:flutter/material.dart';
import 'package:flutter_app/core/remote/remote_sync_status.dart';
import 'package:flutter_app/shared/utils/app_formatters.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class RemoteSyncStatusCard extends StatelessWidget {
  const RemoteSyncStatusCard({
    super.key,
    required this.status,
    this.onRetry,
  });

  final RemoteSyncStatus status;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    final _SyncVisual visual = _resolveVisual(status);
    final String? caption = switch (status.stage) {
      RemoteSyncStage.success when status.lastSuccessfulSyncAt != null =>
        'Last sync ${AppFormatters.compactDateTime(status.lastSuccessfulSyncAt!)}',
      RemoteSyncStage.syncing when status.lastAttemptedAt != null =>
        'Started ${AppFormatters.compactDateTime(status.lastAttemptedAt!)}',
      RemoteSyncStage.error when status.lastAttemptedAt != null =>
        'Latest attempt ${AppFormatters.compactDateTime(status.lastAttemptedAt!)}',
      _ => null,
    };

    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: visual.accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(visual.icon, color: visual.accentColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  visual.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  status.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (caption != null) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    caption,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
                if (status.hasPendingDomains) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    'Pending: ${status.pendingDomains.length} sync area${status.pendingDomains.length == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
                if (status.hasError && onRetry != null) ...<Widget>[
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: () {
                      onRetry!();
                    },
                    child: const Text('Retry sync'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  _SyncVisual _resolveVisual(RemoteSyncStatus status) {
    switch (status.stage) {
      case RemoteSyncStage.disabled:
        return const _SyncVisual(
          title: 'Cloud sync disabled',
          icon: Icons.cloud_off_rounded,
          accentColor: Color(0xFF908A82),
        );
      case RemoteSyncStage.idle:
        return const _SyncVisual(
          title: 'Cloud sync ready',
          icon: Icons.cloud_queue_rounded,
          accentColor: Color(0xFFF6C56B),
        );
      case RemoteSyncStage.syncing:
        return const _SyncVisual(
          title: 'Syncing with backend',
          icon: Icons.sync_rounded,
          accentColor: Color(0xFFF6C56B),
        );
      case RemoteSyncStage.success:
        return const _SyncVisual(
          title: 'Cloud backup active',
          icon: Icons.cloud_done_rounded,
          accentColor: Color(0xFF6ED7A0),
        );
      case RemoteSyncStage.error:
        return const _SyncVisual(
          title: 'Cloud sync needs attention',
          icon: Icons.cloud_off_rounded,
          accentColor: Color(0xFFFF8B5C),
        );
    }
  }
}

class _SyncVisual {
  const _SyncVisual({
    required this.title,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final IconData icon;
  final Color accentColor;
}
