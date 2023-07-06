// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:network_arch/theme/themes.dart';

class CupertinoContentScaffold extends StatelessWidget {
  const CupertinoContentScaffold({
    required this.child,
    this.largeTitle,
    this.navBarTrailingWidget,
    this.customHeader,
    this.scrollController,
    super.key,
  });

  final Widget? largeTitle;
  final Widget? navBarTrailingWidget;
  final Widget? customHeader;
  final ScrollController? scrollController;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoScrollbar(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            customHeader ??
                CupertinoSliverNavigationBar(
                  stretch: true,
                  border: null,
                  backgroundColor:
                      Themes.iOSbgColor.resolveFrom(context).withAlpha(200),
                  largeTitle: largeTitle,
                  trailing: navBarTrailingWidget,
                ),
            SliverToBoxAdapter(child: child),
          ],
        ),
      ),
    );
  }
}
