import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  int _filterIndex = 0;

  static const _green = Color(0xFF2D5A27);
  static const _textDark = Color(0xFF1A1A1A);
  static const _textGrey = Color(0xFF757575);

  static const _filters = ['Tất cả', 'Địa điểm', 'Ẩm thực', 'Tỉnh thành'];

  final List<Map<String, String>> _saved = [
    {
      'title': 'Hội An',
      'location': 'Quảng Nam',
      'category': 'Tỉnh thành',
      'image': 'https://picsum.photos/seed/hoian/800/400',
    },
    {
      'title': 'Mù Cang Chải',
      'location': 'Yên Bái',
      'category': 'Địa điểm',
      'image': 'https://picsum.photos/seed/mucangchai/800/400',
    },
    {
      'title': 'Vịnh Hạ Long',
      'location': 'Quảng Ninh',
      'category': 'Địa điểm',
      'image': 'https://picsum.photos/seed/halong/800/400',
    },
    {
      'title': 'Chợ Bến Thành',
      'location': 'TP. Hồ Chí Minh',
      'category': 'Ẩm thực',
      'image': 'https://picsum.photos/seed/benthanh/800/400',
    },
    {
      'title': 'Tràng An',
      'location': 'Ninh Bình',
      'category': 'Địa điểm',
      'image': 'https://picsum.photos/seed/trangan/800/400',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildFilterTabs(),
          const SizedBox(height: 16),
          Expanded(
            child: _saved.isEmpty ? _buildEmptyState() : _buildCardList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: const Text(
        'Vietnam Explore',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: _textDark,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: _textDark),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Đã lưu',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _textDark,
              height: 1.2,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Lưu lại những nơi bạn muốn quay lại để khám phá sau.',
            style: TextStyle(fontSize: 13, color: _textGrey, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = _filterIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _filterIndex = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: active ? _green : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? _green : const Color(0xFFE0E0E0),
                ),
              ),
              child: Text(
                _filters[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: active ? Colors.white : _textGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: _saved.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _SavedCard(
        data: _saved[i],
        onUnsave: () => setState(() => _saved.removeAt(i)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.bookmark_outline, size: 64, color: Color(0xFFC2C9BB)),
          SizedBox(height: 16),
          Text(
            'Chưa có địa điểm nào được lưu',
            style: TextStyle(
              fontSize: 16,
              color: _textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Khám phá và lưu những nơi bạn yêu thích!',
            style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
          ),
        ],
      ),
    );
  }
}

class _SavedCard extends StatelessWidget {
  final Map<String, String> data;
  final VoidCallback onUnsave;

  const _SavedCard({required this.data, required this.onUnsave});

  static const _orange = Color(0xFFF2994A);
  static const _green = Color(0xFF2D5A27);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 170,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: data['image']!,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(color: const Color(0xFFCCDDD0)),
              errorWidget: (_, __, ___) =>
                  Container(color: const Color(0xFFCCDDD0)),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC000000)],
                  stops: [0.3, 1.0],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data['category']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 42,
              right: 10,
              child: GestureDetector(
                onTap: onUnsave,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bookmark, color: _green, size: 18),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 60,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: Colors.white70),
                      const SizedBox(width: 3),
                      Text(
                        data['location']!,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
