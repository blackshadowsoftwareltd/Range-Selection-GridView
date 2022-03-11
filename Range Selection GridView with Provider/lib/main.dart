import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:range_select_grid/provider/range_provider.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<RangeProvider>(create: (_) => RangeProvider())
      ],
      child: const MaterialApp(home: Home()),
    ));

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RangeProvider>(context, listen: true);
    return Scaffold(
        body: Center(
            child: SizedBox(
      width: 400,
      height: 400,
      child: GestureDetector(
        onPanStart: (details) => provider.onPanStart(details),
        onPanUpdate: (details) => provider.onPanUpdate(details),
        child: GridView.builder(
          itemCount: provider.keys.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5),
          itemBuilder: (context, index) {
            Future.delayed(const Duration(seconds: 1), () {
              final RenderBox renderBox = provider.keys[index].currentContext
                  ?.findRenderObject() as RenderBox;
              final Offset offset = renderBox.localToGlobal(Offset.zero);
              final Size size = renderBox.size;

              if (provider.boxDetails?[index].xf == null) {
                final _data = OffsetDetails(
                    xf: offset.dx,
                    xe: offset.dx + size.width,
                    yf: offset.dy,
                    ye: offset.dy + size.height);
                provider.boxDetails?[index] = _data;
              } else {}
            });

            return GestureDetector(
              onTap: () {
                if (provider.selectedIndex == index) {
                  provider.selectedIndex = null;
                } else if (provider.selectedIndex == null) {
                  provider.selectedIndex = index;
                  provider.startIndex = index;
                  provider.endIndex = null;
                } else if (provider.startIndex != null &&
                    provider.endIndex == null) {
                  provider.selectedIndex = null;
                  provider.endIndex = index;
                  provider.selectedIndex = null;
                } else if (provider.startIndex == index ||
                    provider.endIndex == index ||
                    provider.selectedIndex == index) {
                  provider.startIndex = null;
                  provider.endIndex = null;
                  provider.selectedIndex = null;
                }
              },
              child: Button(
                key: provider.keys[index],
                index: index,
                isSelected: provider.isSelected(index),
              ),
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
            child: Text('${index + 1}',
                style: TextStyle(
                    fontSize: isSelected ? 20 : 18,
                    color: isSelected ? Colors.white : Colors.black))));
  }
}
