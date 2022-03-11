import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final keys = StateProvider(
    (ref) => List<GlobalKey>.generate(25, (index) => GlobalKey()));

final selectedIndex = StateProvider<int?>((ref) => null);
final startIndex = StateProvider<int?>((ref) => null);
final endIndex = StateProvider<int?>((ref) => null);

final boxDetails = StateProvider<List<OffsetDetails?>>((ref) => List.filled(
    ref.read(keys.state).state.length,
    OffsetDetails(xf: null, xe: null, yf: null, ye: null)));

final onPanStart = StateProvider.family<void, DragStartDetails>((ref, details) {
  final _boxDetails = ref.read(boxDetails.state).state;
  final _selectedIndex = ref.read(endIndex.state);
  final _startIndex = ref.read(startIndex.state);
  final _endIndex = ref.read(endIndex.state);

  final _dx = details.globalPosition.dx;
  final _dy = details.globalPosition.dy;
  final _start = _boxDetails.where((e) {
    return _dx > e!.xf! && _dx < e.xe! && _dy > e.yf! && _dy < e.ye!;
  }).toList();
  final _index = _boxDetails.indexOf(_start.first);

  _startIndex.state = _index;
  _endIndex.state = _index;
  _selectedIndex.state = null;
});

final onPanUpdate =
    StateProvider.family<void, DragUpdateDetails>((ref, details) {
  final _boxDetails = ref.read(boxDetails.state).state;
  final _selectedIndex = ref.read(endIndex.state);
  final _endIndex = ref.read(endIndex.state);
  late int _index;
  final _dx = details.globalPosition.dx;
  final _dy = details.globalPosition.dy;
  final _start = _boxDetails.where((e) {
    return _dx >= e!.xf! && _dx <= e.xe! && _dy >= e.yf! && _dy <= e.ye!;
  }).toList();
  try {
    if (_start.isNotEmpty) {
      _index = _boxDetails.indexOf(_start.first);
      _selectedIndex.state = null;
      _endIndex.state = _index;
    }
  } catch (e) {
    print(e.toString());
  }
});
bool isSelected(
    {required int index,
    required int? selectedIndex,
    required int? startIndex,
    required int? endIndex}) {
  if (selectedIndex == null) {
    final _isSelect = startIndex != null && endIndex != null
        ? selectionCheck(index: index, start: startIndex, end: endIndex)
        : false;

    return _isSelect;
  }
  return index == selectedIndex;
}

bool selectionCheck(
    {required int index, required int start, required int end}) {
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

class OffsetDetails {
  final double? xf;
  final double? xe;
  final double? yf;
  final double? ye;

  OffsetDetails(
      {required this.xf, required this.xe, required this.yf, required this.ye});

  // OffsetDetails copyWith({
  //   double? xf,
  //   double? xe,
  //   double? yf,
  //   double? ye,
  // }) {
  //   return OffsetDetails(
  //     xf: xf ?? this.xf,
  //     xe: xe ?? this.xe,
  //     yf: yf ?? this.yf,
  //     ye: ye ?? this.ye,
  //   );
  // }
}
