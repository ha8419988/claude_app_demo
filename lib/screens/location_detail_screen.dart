import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'spot_detail_screen.dart';

class LocationDetailScreen extends StatefulWidget {
  final String title;
  final String region;
  final Color regionColor;
  final String description;
  final String imageUrl;

  const LocationDetailScreen({
    super.key,
    required this.title,
    required this.region,
    required this.regionColor,
    required this.description,
    required this.imageUrl,
  });

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  int _tabIndex = 0;
  bool _saved = false;

  static const _green = Color(0xFF2D5A27);
  static const _textDark = Color(0xFF1A1A1A);
  static const _textGrey = Color(0xFF757575);
  static const _bgGreen = Color(0xFFEAF2EA);

  static const _tabs = [
    {'icon': Icons.park_outlined, 'label': 'Thiên nhiên'},
    {'icon': Icons.history_edu_outlined, 'label': 'Lịch sử'},
    {'icon': Icons.restaurant_outlined, 'label': 'Ẩm thực'},
  ];

  static const _spots = [
    {
      'name': 'Tràng An',
      'desc': 'Quần thể danh thắng di sản UNESCO',
      'image': 'https://picsum.photos/seed/trangan/400/300',
    },
    {
      'name': 'Hang Múa',
      'desc': 'Chinh phục 486 bậc thang',
      'image': 'https://picsum.photos/seed/hangmua/400/300',
    },
    {
      'name': 'Chùa Bái Đính',
      'desc': 'Ngôi chùa lớn nhất Đông Nam Á',
      'image': 'https://picsum.photos/seed/baidinhtemple/400/300',
    },
    {
      'name': 'Cố đô Hoa Lư',
      'desc': 'Kinh đô đầu tiên của Đại Việt',
      'image': 'https://picsum.photos/seed/hoaluu/400/300',
    },
  ];

  static const _dishes = [
    {
      'name': 'Thịt Dê Núi',
      'desc': 'Đặc sản nổi tiếng của vùng núi Ninh Bình',
      'rating': 5,
      'image': 'https://picsum.photos/seed/goatmeat/400/250',
    },
    {
      'name': 'Cơm Cháy Chà Bông',
      'desc': 'Món ăn truyền thống độc đáo',
      'rating': 4,
      'image': 'https://picsum.photos/seed/crispyrice/400/250',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildHeroAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleSection(),
                _buildCategoryTabs(),
                const SizedBox(height: 20),
                _buildInfoCard(),
                const SizedBox(height: 28),
                _buildSectionTitle('Các điểm đến nổi bật'),
                const SizedBox(height: 12),
                _buildSpotsGrid(),
                const SizedBox(height: 28),
                _buildSectionTitle('Ẩm thực nổi bật'),
                const SizedBox(height: 12),
                _buildDishCards(),
                const SizedBox(height: 28),
                _buildDirectionsSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Icon(Icons.arrow_back, color: _textDark, size: 20),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => setState(() => _saved = !_saved),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            padding: const EdgeInsets.all(6),
            child: Icon(
              _saved ? Icons.bookmark : Icons.bookmark_outline,
              color: _saved ? _green : _textDark,
              size: 20,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: const Color(0xFFCCDDD0)),
          errorWidget: (_, __, ___) => Container(color: const Color(0xFFCCDDD0)),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: widget.regionColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.region.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _textDark),
          ),
          const SizedBox(height: 6),
          Text(
            widget.description,
            style: const TextStyle(fontSize: 14, color: _textGrey, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final active = _tabIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _tabIndex = i),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: active ? _green : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: active ? _green : const Color(0xFFE0E0E0)),
              ),
              child: Row(
                children: [
                  Icon(
                    _tabs[i]['icon'] as IconData,
                    size: 16,
                    color: active ? Colors.white : _textGrey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _tabs[i]['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: active ? Colors.white : _textGrey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _bgGreen,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            _buildInfoRow(Icons.wb_sunny_outlined, 'Thời điểm tốt nhất', 'Tháng 5 – Tháng 6'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.directions_car_outlined, 'Khoảng cách từ Hà Nội', '~95 km'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.directions_transit_outlined, 'Phương tiện', 'Tàu hoả, xe buýt, xe máy'),
            const Divider(height: 24, color: Color(0xFFCCDDD0)),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: const [
                  Icon(Icons.map_outlined, size: 16, color: _green),
                  SizedBox(width: 6),
                  Text(
                    'Xem bản đồ đường đi',
                    style: TextStyle(fontSize: 13, color: _green, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Icon(Icons.chevron_right, size: 18, color: _green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _green),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: _textGrey)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _textDark),
      ),
    );
  }

  Widget _buildSpotsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: _spots.length,
        itemBuilder: (_, i) {
          final spot = _spots[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SpotDetailScreen(
                  name: spot['name'] as String,
                  desc: spot['desc'] as String,
                  imageUrl: spot['image'] as String,
                  parentLocation: widget.title,
                ),
              ),
            ),
            child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: spot['image'] as String,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: const Color(0xFFCCDDD0)),
                  errorWidget: (_, __, ___) => Container(color: const Color(0xFFCCDDD0)),
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
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spot['name'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        spot['desc'] as String,
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          );
        },
      ),
    );
  }

  Widget _buildDishCards() {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _dishes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final dish = _dishes[i];
          return Container(
            width: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: dish['image'] as String,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(height: 110, color: const Color(0xFFCCDDD0)),
                    errorWidget: (_, __, ___) => Container(height: 110, color: const Color(0xFFCCDDD0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish['name'] as String,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _textDark),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: List.generate(5, (s) => Icon(
                          s < (dish['rating'] as int) ? Icons.star : Icons.star_border,
                          size: 12,
                          color: const Color(0xFFFFC107),
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDirectionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chỉ đường đến ${widget.title}',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _textDark),
          ),
          const SizedBox(height: 14),
          _buildDirectionRow(
            Icons.directions_car_outlined,
            'Ô tô / Xe máy',
            'Theo Quốc lộ 1A hoặc cao tốc Pháp Vân – Cầu Giẽ – Ninh Bình. Thời gian: 1.5–2 giờ.',
          ),
          const SizedBox(height: 14),
          _buildDirectionRow(
            Icons.train_outlined,
            'Tàu hoả',
            'Các chuyến tàu SE1, SE3, SE5, SE7 từ Hà Nội đến ga trung tâm Ninh Bình.',
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: 'https://picsum.photos/seed/ninhbinhmap/800/300',
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(height: 160, color: const Color(0xFFCCDDD0)),
              errorWidget: (_, __, ___) => Container(height: 160, color: const Color(0xFFCCDDD0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionRow(IconData icon, String title, String detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: _bgGreen, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: _green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
              const SizedBox(height: 4),
              Text(detail, style: const TextStyle(fontSize: 13, color: _textGrey, height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }
}
