import 'package:flutter/material.dart';
import 'package:stockv/BinanceEtfComponent/SingleEtfComponent/singleEtfComponent.dart';
import 'package:stockv/Widgets/CoinDetailsPageWidgets/EtfGraphConnector/singleEtfGraphComponent.dart';

var itemCount = 0;

class CoinDetailPageMultipleEtfContainerState extends StatefulWidget {
  final List<String> savedEtfCodes;

  const CoinDetailPageMultipleEtfContainerState(
      {Key? key, required this.savedEtfCodes})
      : super(key: key);

  @override
  State<CoinDetailPageMultipleEtfContainerState> createState() =>
      _CoinDetailPageMultipleEtfContainerState();
}

class _CoinDetailPageMultipleEtfContainerState
    extends State<CoinDetailPageMultipleEtfContainerState> {
  @override
  void initState() {
    super.initState();
    setState(() {
      itemCount = widget.savedEtfCodes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: (itemCount / 12).ceil(),
      itemBuilder: (context, pageIndex) {
        final startIndex = pageIndex * 12;
        final endIndex = startIndex + 12;
        final pageEtfList = widget.savedEtfCodes
            .sublist(startIndex, endIndex < itemCount ? endIndex : itemCount);
        return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) => SizedBox(
            width: 400.0,
            height: 400.0,
            child:
                SingleEtfGraphComponent(etfCode: pageEtfList.elementAt(index)),
          ),
        );
      },
    );
  }
}