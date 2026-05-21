import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  int _filterIndex = 0;

  static const _filters = ['Tất cả', 'Biển', 'Núi', 'Thành phố', 'Văn hóa'];

  static const _allItems = [
    {
      'title': 'Vịnh Hạ Long',
      'location': 'Quảng Ninh, Việt Nam',
      'category': 'Biển',
      'categoryColor': 0xFF0288D1,
      'rating': 4.9,
      'price': '850.000đ/ngày',
      'originalPrice': '1.200.000đ',
      'image': 'https://picsum.photos/seed/halong/800/400',
    },
    {
      'title': 'Ruộng bậc thang Sapa',
      'location': 'Lào Cai, Việt Nam',
      'category': 'Núi',
      'categoryColor': 0xFF558B2F,
      'rating': 4.8,
      'price': '450.000đ/ngày',
      'originalPrice': '',
      'image': 'https://picsum.photos/seed/sapa/800/400',
    },
    {
      'title': 'Phố cổ Hội An',
      'location': 'Quảng Nam, Việt Nam',
      'category': 'Thành phố',
      'categoryColor': 0xFFE65100,
      'rating': 5.0,
      'price': 'Miễn phí',
      'originalPrice': '',
      'image': 'https://picsum.photos/seed/hoian/800/400',
    },
    {
      'title': 'Cầu Vàng Bà Nà',
      'location': 'Đà Nẵng, Việt Nam',
      'category': 'Núi',
      'categoryColor': 0xFF558B2F,
      'rating': 4.7,
      'price': '700.000đ/vé',
      'originalPrice': '',
      'image': 'https://picsum.photos/seed/cauvanq/800/400',
    },
    {
      'title': 'Tràng An',
      'location': 'Ninh Bình, Việt Nam',
      'category': 'Văn hóa',
      'categoryColor': 0xFF6A1B9A,
      'rating': 4.6,
      'price': '200.000đ/người',
      'originalPrice': '',
      'image': 'https://picsum.photos/seed/trangan/800/400',
    },
    {
      'title': 'Chợ Bến Thành',
      'location': 'TP. Hồ Chí Minh, Việt Nam',
      'category': 'Thành phố',
      'categoryColor': 0xFFE65100,
      'rating': 4.5,
      'price': 'Miễn phí',
      'originalPrice': '',
      'image': 'https://picsum.photos/seed/benthanh/800/400',
    },
  ];

  late List<Map<String, Object>> _saved;

  @override
  void initState() {
    super.initState();
    _saved = List<Map<String, Object>>.from(_allItems);
  }

  List<Map<String, Object>> get _filtered {
    if (_filterIndex == 0) return _saved;
    final cat = _filters[_filterIndex];
    return _saved.where((e) => e['category'] == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(filtered.length),
          _buildFilterTabs(),
          const SizedBox(height: 16),
          Expanded(
            child: filtered.isEmpty ? _buildEmptyState() : _buildCardList(filtered),
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
        'Vietnam Travel',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.text),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.text),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Địa điểm đã lưu',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.text, height: 1.2),
          ),
          const SizedBox(height: 4),
          Text(
            '$count địa điểm',
            style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
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

  Widget _buildCardList(List<Map<String, Object>> items) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _SavedCard(
        data: items[i],
        onUnsave: () => setState(() => _saved.remove(items[i])),
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
            style: TextStyle(fontSize: 16, color: AppColors.textGrey, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6),
          Text(
            'Khám phá và lưu những nơi bạn yêu thích!',
            style: TextStyle(fontSize: 13, color: AppColors.textLightGrey),
          ),
        ],
      ),
    );
  }
}

class _SavedCard extends StatelessWidget {
  final Map<String, Object> data;
  final VoidCallback onUnsave;

  const _SavedCard({required this.data, required this.onUnsave});

  @override
  Widget build(BuildContext context) {
    final originalPrice = data['originalPrice'] as String;
    final hasDiscount = originalPrice.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          _buildContent(hasDiscount, originalPrice),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: data['image'] as String,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: AppColors.cardPlaceholder),
              errorWidget: (_, __, ___) => Container(color: AppColors.cardPlaceholder),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(data['categoryColor'] as int),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data['category'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool hasDiscount, String originalPrice) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['title'] as String,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, size: 14, color: Color(0xFFFFC107)),
              const SizedBox(width: 3),
              Text(
                (data['rating'] as double).toStringAsFixed(1),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textGrey),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  data['location'] as String,
                  style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasDiscount)
                    Text(
                      originalPrice,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textLightGrey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    data['price'] as String,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: hasDiscount ? AppColors.primary : AppColors.text,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onUnsave,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite, color: AppColors.primary, size: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      elevation: 0,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Chi tiết', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
