import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _green = Color(0xFF2D5A27);
  static const _grey = Color(0xFF9E9E9E);

  static const _items = [
    {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Trang chủ'},
    {'icon': Icons.explore_outlined, 'activeIcon': Icons.explore, 'label': 'Khám phá'},
    {'icon': Icons.bookmark_outline, 'activeIcon': Icons.bookmark, 'label': 'Đã lưu'},
    {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'Cá nhân'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE6E6E6))),
      ),
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final active = currentIndex == i;
          final item = _items[i];
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 72,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    active ? item['activeIcon'] as IconData : item['icon'] as IconData,
                    color: active ? _green : _grey,
                    size: 26,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: active ? _green : _grey,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
