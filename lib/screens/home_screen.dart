import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _regionIndex = 0;
  final _searchController = TextEditingController();

  static const _green = Color(0xFF2D5A27);
  static const _textDark = Color(0xFF1A1A1A);
  static const _textGrey = Color(0xFF757575);
  static const _bgGrey = Color(0xFFF5F5F5);
  static const _borderGrey = Color(0xFFE0E0E0);

  static const _regions = ['Tất cả', 'Miền Bắc', 'Miền Nam', 'Miền Trung'];

  static const _destinations = [
    {
      'title': 'Ninh Bình',
      'subtitle': 'Quần thể Tràng An',
      'image':
          'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=600&q=80',
    },
    {
      'title': 'Phú Quốc',
      'subtitle': 'Đảo ngọc miền Nam',
      'image':
          'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=600&q=80',
    },
    {
      'title': 'Hội An',
      'subtitle': 'Phố cổ nghìn năm',
      'image':
          'https://images.unsplash.com/photo-1583417457561-7eadbd3a4001?w=600&q=80',
    },
  ];

  static const _topics = [
    {'icon': Icons.landscape, 'label': 'Núi non'},
    {'icon': Icons.location_on_outlined, 'label': 'Điểm đến'},
    {'icon': Icons.restaurant_outlined, 'label': 'Ẩm thực'},
    {'icon': Icons.account_balance_outlined, 'label': 'Văn hóa'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(),
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildRegionTabs(),
            const SizedBox(height: 24),
            _buildSectionHeader('Địa điểm nổi bật'),
            const SizedBox(height: 12),
            _buildDestinationCards(),
            const SizedBox(height: 28),
            _buildSectionHeader('Tìm kiếm theo chủ đề'),
            const SizedBox(height: 12),
            _buildTopicsGrid(),
            const SizedBox(height: 32),
          ],
        ),
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

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Xin chào, Người lữ hành',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: _textDark,
              height: 1.2,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Hành trình khám phá vẻ đẹp đất tiên của\nViệt Nam bắt đầu từ đây.',
            style: TextStyle(fontSize: 14, color: _textGrey, height: 1.5),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 14, color: _textDark),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm điểm đến, trải nghiệm...',
          hintStyle: const TextStyle(fontSize: 14, color: _textGrey),
          prefixIcon: const Icon(Icons.search, color: _textGrey, size: 20),
          filled: true,
          fillColor: _bgGrey,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildRegionTabs() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _regions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = _regionIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _regionIndex = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: active ? _green : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: active ? _green : _borderGrey),
              ),
              child: Text(
                _regions[i],
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Xem tất cả',
              style: TextStyle(
                  fontSize: 13, color: _green, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCards() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _destinations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final dest = _destinations[i];
          return _DestinationCard(
            title: dest['title'] as String,
            subtitle: dest['subtitle'] as String,
            imageUrl: dest['image'] as String,
          );
        },
      ),
    );
  }

  Widget _buildTopicsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: _topics.length,
        itemBuilder: (_, i) {
          final topic = _topics[i];
          return _TopicItem(
            icon: topic['icon'] as IconData,
            label: topic['label'] as String,
          );
        },
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const _DestinationCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: const Color(0xFFCCDDD0)),
              errorWidget: (_, __, ___) =>
                  Container(color: const Color(0xFFCCDDD0)),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC000000)],
                  stops: [0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
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

class _TopicItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TopicItem({required this.icon, required this.label});

  static const _green = Color(0xFF2D5A27);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2EA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: _green, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
