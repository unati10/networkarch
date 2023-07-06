// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/shared/shared_widgets.dart';

class ToolCard extends StatelessWidget {
  const ToolCard({
    required this.toolName,
    this.toolDesc,
    this.isPremium = false,
    this.onPressed,
    super.key,
  });

  final String toolName;
  final String? toolDesc;
  final bool isPremium;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) {
        return ActionCard(
          title: toolName,
          desc: toolDesc,
          shape: CircleBorder(
            side: isPremium
                ? BorderSide(
                    width: 2,
                    color: Theme.of(context).colorScheme.tertiary,
                  )
                : BorderSide.none,
          ),
          onTap: onPressed,
        );
      },
      iosBuilder: (context) {
        return CupertinoListTile.notched(
          title: Text(toolName),
          subtitle: toolDesc != null
              ? ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 200,
                    maxHeight: 200,
                  ),
                  child: Text(
                    toolDesc!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : null,
          trailing: const CupertinoListTileChevron(),
          onTap: onPressed,
        );
      },
    );
  }
}
