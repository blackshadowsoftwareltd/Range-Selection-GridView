import 'package:flutter/cupertino.dart';

class RangeProvider extends ChangeNotifier {
  final _keys = List<GlobalKey>.generate(25, (index) => GlobalKey());
  List<OffsetDetails>? _boxDetails =
      List.filled(25, OffsetDetails(xf: null, xe: null, yf: null, ye: null));

  int? _startIndex, _endIndex, _selectedIndex;

  List<GlobalKey<State<StatefulWidget>>> get keys => _keys;
  List<OffsetDetails>? get boxDetails => _boxDetails;
  int? get startIndex => _startIndex;
  int? get endIndex => _endIndex;
  int? get selectedIndex => _selectedIndex;

  set boxDetails(List<OffsetDetails>? value) {
    _boxDetails = value;
    notifyListeners();
  }

  set startIndex(int? value) {
    _startIndex = value;
    notifyListeners();
  }

  set endIndex(int? value) {
    _endIndex = value;
    notifyListeners();
  }

  set selectedIndex(int? value) {
    _selectedIndex = value;
    notifyListeners();
  }

  void onPanStart(DragStartDetails details) async {
    final _dx = details.globalPosition.dx;
    final _dy = details.globalPosition.dy;
    final _start = boxDetails!.where((e) {
      return _dx > e.xf! && _dx < e.xe! && _dy > e.yf! && _dy < e.ye!;
    }).toList();
    await Future.delayed(Duration.zero);
    try {
      final _index = boxDetails!.indexOf(_start.first);
      startIndex = _index;
      endIndex = _index;
      selectedIndex = null;
    } catch (e) {
      print(e.toString());
    }
  }

  void onPanUpdate(DragUpdateDetails details) async {
    late int _index;
    final _dx = details.globalPosition.dx;
    final _dy = details.globalPosition.dy;
    final _start = _boxDetails!.where((e) {
      return _dx >= e.xf! && _dx <= e.xe! && _dy >= e.yf! && _dy <= e.ye!;
    }).toList();
    await Future.delayed(Duration.zero);
    try {
      if (_start.isNotEmpty) {
        _index = _boxDetails!.indexOf(_start.first);
        endIndex = _index;
        selectedIndex = null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  bool isSelected(index) {
    if (selectedIndex == null) {
      return startIndex != null && endIndex != null
          ? selection(index: index, start: startIndex!, end: endIndex!)
          : false;
    }
    return index == selectedIndex;
  }

  bool selection({required int index, required int start, required int end}) {
    if (start <= end) {
      if (index >= start && index <= end) {
        return true;
      }
    } else {
      if (index <= start && index >= end) {
        return true;
      }
    }
    return false;
  }
}

class OffsetDetails {
  final double? xf;
  final double? xe;
  final double? yf;
  final double? ye;

  OffsetDetails(
      {required this.xf, required this.xe, required this.yf, required this.ye});
}
