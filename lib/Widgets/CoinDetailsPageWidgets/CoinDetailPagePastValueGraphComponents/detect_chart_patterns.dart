import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stockv/Widgets/CoinDetailsPageWidgets/CoinDetailPagePastValueGraphComponents/single_chart_pattern.dart';

import '../loading_page.dart';

class ChartPatternButtons extends StatefulWidget {
  final String etfCode;
  final String intervalCode;
  final int intervalValue;
  final Duration duration;

  const ChartPatternButtons(
      {super.key,
      required this.etfCode,
      required this.intervalCode,
      required this.intervalValue,
      required this.duration});

  @override
  State<ChartPatternButtons> createState() => _ChartPatternButtonsState();
}

class _ChartPatternButtonsState extends State<ChartPatternButtons> {
  bool isLoading = true;

  List<String> rectanglePlots = [];
  List<String> headAndShouldersPlots = [];
  List<String> triplesPlots = [];
  List<String> wedgePlots = [];
  List<String> trianglePlots = [];
  List<String> supportAndResistancePlots = [];
  List<String> roundingBottomPlots = [];
  List<String> flagPlots = [];
  List<String> doublePlots = [];

  Future<void> fetchPlots(symbol, intervalValue, intervalCode, duration) async {
    final int startTime =
        DateTime.now().subtract(duration).millisecondsSinceEpoch;
    final int endTime = DateTime.now().millisecondsSinceEpoch;
    List<String> rectangles = await fetchChartPatterns(
        symbol, intervalValue, intervalCode, startTime, endTime, 'Rectangle');
    List<String> headAndShoulders = await fetchChartPatterns(symbol,
        intervalValue, intervalCode, startTime, endTime, 'Head and Shoulders');
    List<String> triples = await fetchChartPatterns(
        symbol, intervalValue, intervalCode, startTime, endTime, 'Triples');
    List<String> wedge = await fetchChartPatterns(
        symbol, intervalValue, intervalCode, startTime, endTime, 'Wedge');
    List<String> triangles = await fetchChartPatterns(
        symbol, intervalValue, intervalCode, startTime, endTime, 'Triangle');
    List<String> supportAndResistance = await fetchChartPatterns(
        symbol,
        intervalValue,
        intervalCode,
        startTime,
        endTime,
        'Support and Resistance');
    List<String> roundingBottom = await fetchChartPatterns(symbol,
        intervalValue, intervalCode, startTime, endTime, 'Rounding Bottom');
    List<String> flags = await fetchChartPatterns(
        symbol, intervalValue, intervalCode, startTime, endTime, 'Flag');
    List<String> double = await fetchChartPatterns(
        symbol, intervalValue, intervalCode, startTime, endTime, 'Double');

    setState(() {
      rectanglePlots = rectangles;
      headAndShouldersPlots = headAndShoulders;
      triplesPlots = triples;
      wedgePlots = wedge;
      trianglePlots = triangles;
      supportAndResistancePlots = supportAndResistance;
      roundingBottomPlots = roundingBottom;
      flagPlots = flags;
      doublePlots = double;
      isLoading = false;
    });
  }

  Future<List<String>> fetchChartPatterns(
      String symbol,
      int intervalValue,
      String intervalCode,
      int startTime,
      int endTime,
      String patternType,
      ) async {
    const url = 'http://10.0.2.2:8000/get-chart-patterns/';

    final request = http.Request('POST', Uri.parse(url));
    request.headers["Content-Type"] = "application/json";
    request.body = json.encode({
      'symbol': symbol,
      'intervalValue': intervalValue,
      'intervalCode': intervalCode,
      'startTime': startTime,
      'endTime': endTime,
      'chartType': patternType,
    });

    // Set a longer timeout duration (e.g., 30 seconds)
    final response = await http.Response.fromStream(
        await http.Client().send(request).timeout(const Duration(seconds: 30)));

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);

      // Convert the dynamic list to a List<String> of plots
      List<String> fetchedPlots = List<String>.from(parsedResponse);
      print(patternType);
      return fetchedPlots;
    } else {
      throw Exception('Failed to fetch plots');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPlots(widget.etfCode, widget.intervalValue, widget.intervalCode,
        widget.duration);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingScreen();
    } else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            leadingWidth: 400,
            leading: Row(children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Image.asset('images/black.png'),
            ]),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (rectanglePlots.isEmpty) {
                          return Colors
                              .grey; // Change the color for disabled state
                        }
                        return Colors.deepPurpleAccent; // Default color
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () { rectanglePlots.isEmpty ? null :
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlotDisplayScreen(plots: rectanglePlots, chartPatternType: 'Rectangle', coinSymbol: widget.etfCode,)));
                  },
                  child: const Text(
                    'SEE RECTANGLE PATTERN',
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (headAndShouldersPlots.isEmpty) {
                          return Colors
                              .grey; // Change the color for disabled state
                        }
                        return Colors.deepPurpleAccent; // Default color
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () { headAndShouldersPlots.isEmpty ? null :
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlotDisplayScreen(plots: headAndShouldersPlots, chartPatternType: 'Head & Shoulders', coinSymbol: widget.etfCode,)));
                  },
                  child: const Text(
                    'SEE HEAD & SHOULDERS PATTERN',
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (triplesPlots.isEmpty) {
                          return Colors
                              .grey; // Change the color for disabled state
                        }
                        return Colors.deepPurpleAccent; // Default color
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () { triplesPlots.isEmpty ? null :
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlotDisplayScreen(plots: triplesPlots, chartPatternType: 'Triples', coinSymbol: widget.etfCode,)));
                  },
                  child: const Text(
                    'SEE TRIPLES PATTERN',
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (wedgePlots.isEmpty) {
                          return Colors
                              .grey; // Change the color for disabled state
                        }
                        return Colors.deepPurpleAccent; // Default color
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () { wedgePlots.isEmpty ? null :
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlotDisplayScreen(plots: wedgePlots, chartPatternType: 'Wedge', coinSymbol: widget.etfCode,)));
                  },
                  child: const Text(
                    'SEE WEDGE PATTERN',
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (trianglePlots.isEmpty) {
                          return Colors
                              .grey; // Change the color for disabled state
                        }
                        return Colors.deepPurpleAccent; // Default color
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () { trianglePlots.isEmpty ? null :
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlotDisplayScreen(plots: trianglePlots, chartPatternType: 'Triangle', coinSymbol: widget.etfCode,)));
                  },
                  child: const Text(
                    'SEE TRIANGLE PATTERN',
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (supportAndResistancePlots.isEmpty) {
                          return Colors
                              .grey; // Change the color for disabled state
                        }
                        return Colors.deepPurpleAccent; // Default color
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () { supportAndResistancePlots.isEmpty ? null :
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlotDisplayScreen(plots: supportAndResistancePlots, chartPatternType: 'Support & Resistance', coinSymbol: widget.etfCode,)));
                  },
                  child: const Text(
                    'SEE SUPPORT & RESISTANCE PATTERN',
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (roundingBottomPlots.isEmpty) {
                          return Colors
                              .grey; // Change the color for disabled state
                        }
                        return Colors.deepPurpleAccent; // Default color
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () { roundingBottomPlots.isEmpty ? null :
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlotDisplayScreen(plots: roundingBottomPlots, chartPatternType: 'Rounding Bottom', coinSymbol: widget.etfCode,)));
                  },
                  child: const Text(
                    'SEE ROUNDING BOTTOM PATTERN',
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (flagPlots.isEmpty) {
                          return Colors
                              .grey; // Change the color for disabled state
                        }
                        return Colors.deepPurpleAccent; // Default color
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () { flagPlots.isEmpty ? null :
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlotDisplayScreen(plots: flagPlots, chartPatternType: 'Flag', coinSymbol: widget.etfCode,)));
                  },
                  child: const Text(
                    'SEE FLAG PATTERN',
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (doublePlots.isEmpty) {
                          return Colors
                              .grey; // Change the color for disabled state
                        }
                        return Colors.deepPurpleAccent; // Default color
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: () { doublePlots.isEmpty ? null :
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlotDisplayScreen(plots: doublePlots, chartPatternType: 'Double', coinSymbol: widget.etfCode,)));
                  },
                  child: const Text(
                    'SEE DOUBLE PATTERN',
                  ),
                ),
              ],
            ),
          ));
    }
  }
}
