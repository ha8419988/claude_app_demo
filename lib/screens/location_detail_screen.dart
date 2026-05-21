import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'booking_screen.dart';

class LocationDetailScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String location;
  final String? description;
  final double rating;
  final int reviews;
  final String price;
  final String badge;

  // kept for backward compat with explore_screen (unused in new design)
  final String? region;
  final Color? regionColor;

  const LocationDetailScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    this.location = '',
    this.description,
    this.rating = 4.8,
    this.reviews = 32,
    this.price = '2.400.000',
    this.badge = 'Phổ biến',
    this.region,
    this.regionColor,
  });

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  bool _saved = false;

  static const _amenities = [
    (Icons.wifi, 'Wi-Fi'),
    (Icons.pool_outlined, 'Hồ bơi'),
    (Icons.restaurant_outlined, 'Nhà hàng'),
    (Icons.spa_outlined, 'Spa'),
    (Icons.fitness_center_outlined, 'Gym'),
    (Icons.local_parking_outlined, 'Bãi đỗ xe'),
    (Icons.air_outlined, 'Điều hoà'),
    (Icons.beach_access_outlined, 'Bãi biển'),
  ];

  static const _gallery = [
    'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&q=80',
    'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400&q=80',
    'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&q=80',
    'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=400&q=80',
  ];

  static const _reviews = [
    (
      name: 'Nguyễn Minh Tuấn',
      rating: 5,
      comment: 'Resort rất đẹp, dịch vụ tuyệt vời. Nhân viên thân thiện và chuyên nghiệp. Sẽ quay lại lần sau!',
      date: '2 tuần trước',
    ),
    (
      name: 'Trần Thu Hà',
      rating: 4,
      comment: 'View biển tuyệt đẹp, phòng rộng rãi sạch sẽ. Đồ ăn sáng rất ngon. Chỉ hơi xa trung tâm một chút.',
      date: '1 tháng trước',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildHero(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const Divider(height: 1, color: AppColors.borderGrey),
                _buildDescription(),
                _buildAmenities(),
                _buildGallery(),
                _buildReviews(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHero() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Colors.white, shape: BoxShape.circle),
          child: const Icon(Icons.arrow_back, color: AppColors.text, size: 20),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => setState(() => _saved = !_saved),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            padding: const EdgeInsets.all(6),
            child: Icon(
              _saved ? Icons.favorite : Icons.favorite_border,
              color: _saved ? AppColors.primary : AppColors.text,
              size: 20,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) =>
              Container(color: AppColors.cardPlaceholder),
          errorWidget: (_, __, ___) =>
              Container(color: AppColors.cardPlaceholder),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.badge.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    widget.badge,
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    widget.rating.toString(),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${widget.reviews} đánh giá)',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textGrey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.title,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text),
          ),
          const SizedBox(height: 8),
          if (widget.location.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: AppColors.textGrey, size: 15),
                const SizedBox(width: 4),
                Text(
                  widget.location,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textGrey),
                ),
              ],
            ),
          if (widget.price.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${widget.price}đ',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                ),
                const SizedBox(width: 4),
                const Padding(
                  padding: EdgeInsets.only(bottom: 2),
                  child: Text(
                    '/đêm',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textGrey),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescription() {
    final desc = widget.description ??
        'Khu nghỉ dưỡng sang trọng bậc nhất tọa lạc tại bãi biển đẹp nhất Việt Nam. Kiến trúc Đông Á tinh tế kết hợp tiện nghi đẳng cấp thế giới, mang đến trải nghiệm nghỉ dưỡng khó quên.';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mô tả',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text)),
          const SizedBox(height: 10),
          Text(desc,
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                  height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildAmenities() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppColors.borderGrey),
          const SizedBox(height: 12),
          const Text('Tiện nghi',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _amenities.map((a) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(a.$1, size: 15, color: AppColors.textGrey),
                    const SizedBox(width: 6),
                    Text(a.$2,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.text)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: AppColors.borderGrey),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ảnh thực tế',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text)),
              GestureDetector(
                onTap: () {},
                child: const Text('Xem tất cả',
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _gallery.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: _gallery[i],
                width: 140,
                height: 110,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(width: 140, color: AppColors.cardPlaceholder),
                errorWidget: (_, __, ___) =>
                    Container(width: 140, color: AppColors.cardPlaceholder),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: AppColors.borderGrey),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đánh giá (${widget.reviews})',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text('Xem tất cả',
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        ..._reviews.map((r) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.15),
                        child: Text(
                          r.name[0],
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.name,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.text)),
                            Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (i) => Icon(
                                    i < r.rating
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    color: Colors.amber,
                                    size: 13,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(r.date,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textGrey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(r.comment,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                          height: 1.5)),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.price.isNotEmpty) ...[
                Text(
                  '${widget.price}đ',
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                ),
                const Text('/đêm',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textGrey)),
              ],
            ],
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.explore_outlined, size: 18),
            label: const Text('Chỉ đường'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingScreen(
                  propertyName: widget.title,
                  price: widget.price,
                  location: widget.location,
                  imageUrl: widget.imageUrl,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
            ),
            child: const Text('Đặt ngay',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
