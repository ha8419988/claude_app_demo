import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'location_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _filterIndex = 0;
  final _searchController = TextEditingController();

  static const _green = Color(0xFF2D5A27);
  static const _textDark = Color(0xFF1A1A1A);
  static const _textGrey = Color(0xFF757575);
  static const _bgGrey = Color(0xFFF5F5F5);

  static const _filters = ['Tất cả', 'Miền Bắc', 'Miền Trung', 'Miền Nam', 'Tây Nguyên'];

  static const _featured = [
    {
      'title': 'Đà Nẵng',
      'desc': 'Thành phố cầu và bãi biển đẹp nhất miền Trung',
      'region': 'Miền Trung',
      'regionColor': 0xFFE65100,
      'image': 'https://picsum.photos/seed/danang/800/420',
      'large': true,
    },
    {
      'title': 'Lào Cai',
      'desc': 'Vùng đất của mây mù và ruộng bậc thang',
      'region': 'Miền Bắc',
      'regionColor': 0xFF1565C0,
      'image': 'https://picsum.photos/seed/laocai/800/420',
      'large': true,
    },
    {
      'title': 'Quảng Ninh',
      'desc': 'Vịnh Hạ Long kỳ quan thiên nhiên',
      'region': 'Miền Bắc',
      'regionColor': 0xFF1565C0,
      'image': 'https://picsum.photos/seed/quangninh/400/300',
      'large': false,
    },
    {
      'title': 'TP. Hồ Chí Minh',
      'desc': 'Hòn ngọc Viễn Đông sầm uất',
      'region': 'Miền Nam',
      'regionColor': 0xFF2D5A27,
      'image': 'https://picsum.photos/seed/hcmc/400/300',
      'large': false,
    },
    {
      'title': 'Thừa Thiên Huế',
      'desc': 'Cố đô ngàn năm văn hiến',
      'region': 'Miền Trung',
      'regionColor': 0xFFE65100,
      'image': 'https://picsum.photos/seed/hue/800/420',
      'large': true,
    },
  ];

  static const _provinces = [
    'Hà Nội', 'Hải Phòng', 'Cần Thơ', 'Khánh Hòa',
    'Lâm Đồng', 'Ninh Bình', 'Phú Quốc', 'Bình Thuận',
    'Quảng Nam', 'Đắk Lắk', 'An Giang', 'Hà Giang',
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Vietnam Explore',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _textDark),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: _textDark), onPressed: () {}),
          const SizedBox(width: 4),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildFilterTabs(),
                const SizedBox(height: 20),
                _buildFeaturedGrid(),
                const SizedBox(height: 28),
                _buildProvinceList(),
                const SizedBox(height: 16),
              ],
            ),
          ),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Khám phá 63 tỉnh thành',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark, height: 1.2),
          ),
          SizedBox(height: 6),
          Text(
            'Từ đỉnh núi mây phủ đến bãi biển cát trắng,\nViệt Nam luôn có điều mới để khám phá.',
            style: TextStyle(fontSize: 13, color: _textGrey, height: 1.5),
          ),
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
          hintText: 'Tìm kiếm tỉnh thành...',
          hintStyle: const TextStyle(fontSize: 14, color: _textGrey),
          prefixIcon: const Icon(Icons.search, color: _textGrey, size: 20),
          suffixIcon: const Icon(Icons.tune, color: _textGrey, size: 20),
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
                border: Border.all(color: active ? _green : const Color(0xFFE0E0E0)),
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

  void _openDetail(BuildContext context, Map<String, Object> d) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocationDetailScreen(
          title: d['title'] as String,
          region: d['region'] as String,
          regionColor: Color(d['regionColor'] as int),
          description: d['desc'] as String,
          imageUrl: d['image'] as String,
        ),
      ),
    );
  }

  Widget _buildFeaturedGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _FeaturedCard(data: _featured[0], height: 200, onTap: () => _openDetail(context, _featured[0])),
          const SizedBox(height: 10),
          _FeaturedCard(data: _featured[1], height: 200, onTap: () => _openDetail(context, _featured[1])),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _FeaturedCard(data: _featured[2], height: 160, onTap: () => _openDetail(context, _featured[2]))),
              const SizedBox(width: 10),
              Expanded(child: _FeaturedCard(data: _featured[3], height: 160, onTap: () => _openDetail(context, _featured[3]))),
            ],
          ),
          const SizedBox(height: 10),
          _FeaturedCard(data: _featured[4], height: 200, onTap: () => _openDetail(context, _featured[4])),
        ],
      ),
    );
  }

  Widget _buildProvinceList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tất cả tỉnh thành',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _textDark),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 4,
            ),
            itemCount: _provinces.length,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LocationDetailScreen(
                    title: _provinces[i],
                    region: 'Việt Nam',
                    regionColor: const Color(0xFF2D5A27),
                    description: 'Khám phá vẻ đẹp và văn hóa đặc sắc của ${_provinces[i]}.',
                    imageUrl: 'https://picsum.photos/seed/${_provinces[i]}/800/420',
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: _green),
                  const SizedBox(width: 6),
                  Text(
                    _provinces[i],
                    style: const TextStyle(fontSize: 14, color: _textDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.map_outlined, size: 18),
            label: const Text('Xem bản đồ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Map<String, Object> data;
  final double height;
  final VoidCallback? onTap;

  const _FeaturedCard({required this.data, required this.height, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: data['image'] as String,
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
                  stops: [0.35, 1.0],
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(data['regionColor'] as int),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data['region'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
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
                    data['title'] as String,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data['desc'] as String,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
