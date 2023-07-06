// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/shared/shared.dart';

class CarrierDetailView extends StatelessWidget {
  const CarrierDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIOS,
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoContentScaffold(
      largeTitle: const Text('Carrier Details'),
      child: _buildDataList(context),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carrier Details',
        ),
      ),
      body: _buildDataList(context),
    );
  }

  Widget _buildDataList(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return ContentListView(
      children: [
        BlocBuilder<NetworkStatusBloc, NetworkStatusState>(
          builder: (context, state) {
            return state.wifiStatus == NetworkStatus.success
                ? RoundedList(
                    padding: isIOS ? EdgeInsets.zero : const EdgeInsets.all(10),
                    children: [
                      ListTextLine(
                        widgetL: const Text('VoIP Support'),
                        widgetR: state.carrierInfo!.allowsVOIP
                            ? const Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              )
                            : const Text(
                                'No',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                      ),
                      ListTextLine(
                        widgetL: const Text('Carrier Name'),
                        widgetR: Text(
                          state.carrierInfo!.carrierName ?? 'N/A',
                        ),
                      ),
                      ListTextLine(
                        widgetL: const Text('ISO Country Code'),
                        widgetR: Text(
                          state.carrierInfo!.isoCountryCode ?? 'N/A',
                        ),
                      ),
                      ListTextLine(
                        widgetL: const Text('Mobile Country Code'),
                        widgetR: Text(
                          state.carrierInfo!.mobileCountryCode ?? 'N/A',
                        ),
                      ),
                      ListTextLine(
                        widgetL: const Text('Mobile Network Code'),
                        widgetR: Text(
                          state.carrierInfo!.mobileNetworkCode ?? 'N/A',
                        ),
                      ),
                      ListTextLine(
                        widgetL: const Text('Network Generation'),
                        widgetR: Text(
                          state.carrierInfo!.networkGeneration ?? 'N/A',
                        ),
                      ),
                      ListTextLine(
                        widgetL: const Text('Radio Access Technology'),
                        widgetR: Text(
                          state.carrierInfo!.radioType ?? 'N/A',
                        ),
                      ),
                      if (state.extIpStatus == NetworkStatus.success)
                        ListTextLine(
                          widgetL: const Text('External IPv4'),
                          widgetR: Text(state.extIP.toString()),
                          subtitle: const Text('Tap to refresh'),
                          onRefreshTap: () => _handleExtIPRefresh(context),
                        )
                      else if (state.extIpStatus == NetworkStatus.loading)
                        const ListTextLine(
                          widgetL: Text('External IPv4'),
                          subtitle: Text('Tap to refresh'),
                        )
                      else
                        ListTextLine(
                          widgetL: const Text('External IPv4'),
                          widgetR: const Text('N/A'),
                          subtitle: const Text('Tap to refresh'),
                          onRefreshTap: () => _handleExtIPRefresh(context),
                        ),
                    ],
                  )
                : const RoundedList(
                    children: [
                      ListTextLine(widgetL: Text('VoIP Support')),
                      ListTextLine(widgetL: Text('Carrier Name')),
                      ListTextLine(widgetL: Text('ISO Country Code')),
                      ListTextLine(widgetL: Text('Mobile Country Code')),
                      ListTextLine(widgetL: Text('Mobile Network Code')),
                      ListTextLine(widgetL: Text('Network Generation')),
                      ListTextLine(widgetL: Text('Radio Access Technology')),
                      ListTextLine(widgetL: Text('External IPv4')),
                    ],
                  );
          },
        ),
      ],
    );
  }

  void _handleExtIPRefresh(BuildContext context) {
    context.read<NetworkStatusBloc>().add(NetworkStatusExtIPRequested());
  }
}
