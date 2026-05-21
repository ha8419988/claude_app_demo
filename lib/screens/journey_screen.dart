import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  int _filterIndex = 0;

  static const _filters = ['Sắp tới', 'Đang diễn ra', 'Đã đi'];

  static const _trips = [
    {
      'title': 'Mùa Hè Rực Rỡ',
      'location': 'Hạ Long, Quảng Ninh',
      'dates': '15 Th06 - 20 Th06, 2025',
      'days': 5,
      'status': 'upcoming',
      'image': 'https://picsum.photos/seed/halong/800/400',
    },
    {
      'title': 'Phố Cổ Hội An',
      'location': 'Hội An, Quảng Nam',
      'dates': '01 Th07 - 04 Th07, 2025',
      'days': 4,
      'status': 'upcoming',
      'image': 'https://picsum.photos/seed/hoian/800/400',
    },
    {
      'title': 'Sapa Mù Sương',
      'location': 'Lào Cai',
      'dates': '10 Th08 - 14 Th08, 2025',
      'days': 5,
      'status': 'planning',
      'image': 'https://picsum.photos/seed/sapa/800/400',
    },
    {
      'title': 'Đà Nẵng Biển Xanh',
      'location': 'Đà Nẵng',
      'dates': '19 Th05 - 22 Th05, 2025',
      'days': 3,
      'status': 'ongoing',
      'image': 'https://picsum.photos/seed/danang/800/400',
    },
    {
      'title': 'Hà Giang Loop',
      'location': 'Hà Giang',
      'dates': '01 Th04 - 05 Th04, 2025',
      'days': 5,
      'status': 'completed',
      'image': 'https://picsum.photos/seed/hagiang/800/400',
    },
    {
      'title': 'Tràng An Cổ Kính',
      'location': 'Ninh Bình',
      'dates': '10 Th03 - 12 Th03, 2025',
      'days': 3,
      'status': 'completed',
      'image': 'https://picsum.photos/seed/trangan/800/400',
    },
  ];

  List<Map<String, Object>> get _filtered {
    if (_filterIndex == 0) {
      return _trips.where((t) => t['status'] == 'upcoming' || t['status'] == 'planning').toList();
    } else if (_filterIndex == 1) {
      return _trips.where((t) => t['status'] == 'ongoing').toList();
    } else {
      return _trips.where((t) => t['status'] == 'completed').toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildFilterTabs()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          if (filtered.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else ...[
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _TripCard(data: filtered[i]),
                  ),
                  childCount: filtered.length,
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildCTA()),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
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
        'Vietnam Travel',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.text),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.add, color: AppColors.text), onPressed: () {}),
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
            'Hành trình của tôi',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.text, height: 1.2),
          ),
          SizedBox(height: 4),
          Text(
            'Theo dõi và quản lý các chuyến đi sắp tới.',
            style: TextStyle(fontSize: 13, color: AppColors.textGrey, height: 1.5),
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
                color: active ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: active ? AppColors.primary : AppColors.borderGrey),
              ),
              child: Text(
                _filters[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: active ? Colors.white : AppColors.textGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCTA() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            const Text(
              'Sẵn sàng cho chuyến đi mới?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.text),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tạo hành trình mới'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.map_outlined, size: 64, color: Color(0xFFC2C9BB)),
          SizedBox(height: 16),
          Text(
            'Chưa có hành trình nào',
            style: TextStyle(fontSize: 16, color: AppColors.textGrey, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6),
          Text(
            'Hãy tạo chuyến đi đầu tiên của bạn!',
            style: TextStyle(fontSize: 13, color: AppColors.textLightGrey),
          ),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final Map<String, Object> data;

  const _TripCard({required this.data});

  static const _statusConfig = {
    'upcoming': {'label': 'Sắp tới', 'color': 0xFF1565C0},
    'planning': {'label': 'Lập kế hoạch', 'color': 0xFFF2994A},
    'ongoing': {'label': 'Đang diễn ra', 'color': 0xFF2D5A27},
    'completed': {'label': 'Đã đi', 'color': 0xFF757575},
  };

  @override
  Widget build(BuildContext context) {
    final status = data['status'] as String;
    final config = _statusConfig[status]!;
    final isPlanning = status == 'planning';
    final isCompleted = status == 'completed';

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: data['image'] as String,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: AppColors.cardPlaceholder),
              errorWidget: (_, __, ___) => Container(color: AppColors.cardPlaceholder),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.overlayDark],
                  stops: [0.3, 1.0],
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(config['color'] as int),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  config['label'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite_border, color: Colors.white, size: 17),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'] as String,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(
                        data['dates'] as String,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(
                        '${data['days']} ngày  ·  ${data['location']}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCompleted ? Colors.white.withValues(alpha: 0.25) : Colors.white,
                        foregroundColor: isCompleted ? Colors.white : AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        elevation: 0,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        isPlanning ? 'Tiếp tục lập kế hoạch' : isCompleted ? 'Xem lại' : 'Xem lịch trình',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
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
