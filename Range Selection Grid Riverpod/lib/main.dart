import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider/state_provider.dart';

void main() => runApp(const ProviderScope(child: MaterialApp(home: Home())));

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    final _boxDetails = widgetRef.read(boxDetails.state).state;
    final _keys = widgetRef.read(keys.state).state;
    return Scaffold(
        body: Center(
            child: SizedBox(
      width: 400,
      height: 400,
      child: GestureDetector(
        onPanStart: (details) => widgetRef.read(onPanStart(details)),
        onPanUpdate: (details) => widgetRef.read(onPanUpdate(details)),
        child: GridView.builder(
          itemCount: _keys.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5),
          itemBuilder: (context, index) {
            Future.delayed(const Duration(seconds: 1), () {
              final RenderBox renderBox =
                  _keys[index].currentContext?.findRenderObject() as RenderBox;
              final Offset offset = renderBox.localToGlobal(Offset.zero);
              final Size size = renderBox.size;

              if (_boxDetails[index]!.xf == null) {
                final _data = OffsetDetails(
                    xf: offset.dx,
                    xe: offset.dx + size.width,
                    yf: offset.dy,
                    ye: offset.dy + size.height);
                final _ref = widgetRef.read(boxDetails.state);
                List<OffsetDetails?> _list = _ref.state;
                _list[index] = _data;

                _ref.state = _ref.state = _list;
              } else {}
            });

            return Consumer(
              builder: (_, ref, __) {
                final _selectedIndex = ref.read(selectedIndex.state);
                final _startIndex = ref.read(startIndex.state);
                final _endIndex = ref.read(endIndex.state);
                return GestureDetector(
                  onTap: () {
                    if (_selectedIndex.state == index) {
                      _selectedIndex.state = null;
                    } else if (_selectedIndex.state == null) {
                      _selectedIndex.state = index;
                      _startIndex.state = index;
                      _endIndex.state = null;
                    } else if (_startIndex.state != null &&
                        _endIndex.state == null) {
                      _selectedIndex.state = null;
                      _endIndex.state = index;
                      _selectedIndex.state = null;
                    } else if (_startIndex.state == index ||
                        _endIndex.state == index ||
                        _selectedIndex.state == index) {
                      _startIndex.state = null;
                      _endIndex.state = null;
                      _selectedIndex.state = null;
                    }
                  },
                  child: Button(
                    key: _keys[index],
                    index: index,
                    isSelected: isSelected(
                        index: index,
                        selectedIndex: ref.watch(selectedIndex.state).state,
                        startIndex: ref.watch(startIndex.state).state,
                        endIndex: ref.watch(endIndex.state).state),
                  ),
                );
              },
            );
          },
        ),
      ),
    )));
  }
}

class Button extends StatelessWidget {
  const Button({
    required this.key,
    required this.index,
    required this.isSelected,
  }) : super(key: key);
  final GlobalKey key;
  final int index;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: isSelected ? const EdgeInsets.all(1) : const EdgeInsets.all(3),
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
          color: isSelected ? Colors.lightBlueAccent.shade400 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              width: 1,
              color: isSelected ? Colors.transparent : Colors.black54)),
      child: Center(
        child: Text(
          '${index + 1}',
          style: TextStyle(
              fontSize: isSelected ? 20 : 18,
              color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
