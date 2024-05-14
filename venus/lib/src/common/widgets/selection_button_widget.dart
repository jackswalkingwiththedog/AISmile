import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SelectionButtonData {
  final IconData activeIcon;
  final IconData icon;
  final String label;
  final int? totalNotification;
  final Function() onPress;
  final String page;

  SelectionButtonData({
    required this.activeIcon,
    required this.icon,
    required this.label,
    required this.onPress,
    required this.page,
    this.totalNotification,
  });
}

class SelectionButton extends StatefulWidget {
  const SelectionButton({
    required this.page,
    required this.data,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final String page;
  final List<SelectionButtonData> data;
  final Function(int index, SelectionButtonData value) onSelected;

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.data.asMap().entries.map((e) {
        final index = e.key;
        final data = e.value;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Button(
            selected: selected == data.page,
            onPressed: () {
              widget.onSelected(index, data);
              setState(() {
                selected == data.page;
              });
              data.onPress();
            },
            data: data,
          ),
        );
      }).toList(),
    ); 
  }
}

class Button extends StatelessWidget {
  final bool selected;
  final SelectionButtonData data;
  final Function() onPressed;

  const Button({
    Key? key,
    required this.selected,
    required this.data,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: (selected) ? HexColor("#DB1A20") : HexColor("#FFFFFF"),
      child: InkWell(
        onTap: () {
          onPressed();
        },
        hoverColor: HexColor("#80D32F2F"),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                color: (selected) ? Colors.white : Colors.black87,
                (selected) ? data.activeIcon : data.icon,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data.label,
                  style: TextStyle(
                    color: (selected) ? Colors.white : Colors.black87,
                    fontSize: 14,
                  ),
                )
              )
            ],
          ),
        )
      )
    );
  }
}
