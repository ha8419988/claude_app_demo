import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SpotDetailScreen extends StatefulWidget {
  final String name;
  final String desc;
  final String imageUrl;
  final String parentLocation;

  const SpotDetailScreen({
    super.key,
    required this.name,
    required this.desc,
    required this.imageUrl,
    required this.parentLocation,
  });

  @override
  State<SpotDetailScreen> createState() => _SpotDetailScreenState();
}

class _SpotDetailScreenState extends State<SpotDetailScreen> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeroAppBar(context),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleSection(),
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    _buildIntroSection(),
                    const SizedBox(height: 24),
                    _buildReviewSection(),
                    const SizedBox(height: 24),
                    _buildMapSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          _buildBookingButton(),
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
          child: Icon(Icons.arrow_back, color: AppColors.text, size: 20),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: IconButton(
            icon: Icon(Icons.share_outlined, color: AppColors.text, size: 20),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _saved = !_saved),
          child: Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            padding: const EdgeInsets.all(6),
            child: Icon(
              _saved ? Icons.bookmark : Icons.bookmark_outline,
              color: _saved ? AppColors.primaryGreen : AppColors.text,
              size: 20,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: AppColors.cardPlaceholder),
          errorWidget: (_, __, ___) => Container(color: AppColors.cardPlaceholder),
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.blueLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium_outlined, size: 13, color: AppColors.blue),
                const SizedBox(width: 4),
                Text('UNESCO', style: TextStyle(fontSize: 11, color: AppColors.blue, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.name,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.text),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 14, color: AppColors.textGrey),
              const SizedBox(width: 4),
              Text(
                '${widget.parentLocation}, Việt Nam',
                style: TextStyle(fontSize: 13, color: AppColors.textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          _StatChip(icon: Icons.payments_outlined, label: '250k VNĐ'),
          const SizedBox(width: 8),
          _StatChip(icon: Icons.schedule_outlined, label: '3–4 tiếng'),
          const SizedBox(width: 8),
          _StatChip(icon: Icons.access_time_outlined, label: '07:00–16:00'),
          const SizedBox(width: 8),
          _StatChip(icon: Icons.star, label: '4.8 (2k+)', starColor: AppColors.yellow),
        ],
      ),
    );
  }

  Widget _buildIntroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giới thiệu chi tiết',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.text),
          ),
          const SizedBox(height: 10),
          Text(
            widget.desc.isNotEmpty
                ? widget.desc
                : 'Quần thể danh thắng Tràng An là di sản hỗn hợp đầu tiên của Việt Nam được UNESCO công nhận. Nằm giữa những ngọn núi đá vôi hùng vĩ hàng triệu năm tuổi, nơi đây là điểm giao thoa độc đáo giữa thiên nhiên kỳ vĩ, lịch sử văn hóa lâu đời và hệ sinh thái phong phú.',
            style: TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.6),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _Hashtag('#ThuyềnTràngAn'),
              _Hashtag('#HangĐộng'),
              _Hashtag('#DiSảnUNESCO'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đánh giá cộng đồng',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.text),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Xem tất cả',
                  style: TextStyle(fontSize: 13, color: AppColors.primaryGreen, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primaryGreen,
                      child: const Text('AN', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Minh Anh', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text)),
                          Row(
                            children: [
                              ...List.generate(5, (i) => Icon(Icons.star, size: 12, color: AppColors.yellow)),
                              const SizedBox(width: 6),
                              Text('2 ngày trước', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '"Trải nghiệm tuyệt vời! Chuyến đi thuyền qua các hang động thực sự rất ấn tượng. Cảnh quan thiên nhiên hùng vĩ, không khí trong lành. Nhất định sẽ quay lại!"',
                  style: TextStyle(fontSize: 13, color: AppColors.textGrey, height: 1.5, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: 'https://picsum.photos/seed/mapview/800/300',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(height: 150, color: AppColors.backgroundGreen),
              errorWidget: (_, __, ___) => Container(height: 150, color: AppColors.backgroundGreen),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined, size: 16, color: AppColors.primaryGreen),
                      const SizedBox(width: 6),
                      Text('Xem trên bản đồ', style: TextStyle(fontSize: 13, color: AppColors.primaryGreen, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.navigation_outlined, size: 16),
                  label: const Text('Chỉ đường ngay', style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingButton() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 24,
      child: SizedBox(
        height: 52,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
          ),
          child: const Text('Đặt vé ngay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? starColor;

  const _StatChip({required this.icon, required this.label, this.starColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: starColor ?? AppColors.primaryGreen),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.text)),
        ],
      ),
    );
  }
}

class _Hashtag extends StatelessWidget {
  final String tag;
  const _Hashtag(this.tag);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(tag, style: TextStyle(fontSize: 12, color: AppColors.primaryGreen, fontWeight: FontWeight.w500)),
    );
  }
}
