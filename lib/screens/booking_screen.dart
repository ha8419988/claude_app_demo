import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'guest_count_screen.dart';

class BookingScreen extends StatefulWidget {
  final String propertyName;
  final String location;
  final String imageUrl;
  final String price;

  const BookingScreen({
    super.key,
    required this.propertyName,
    required this.price,
    this.location = '',
    this.imageUrl = '',
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late DateTime _checkIn;
  late DateTime _checkOut;
  bool _pickingCheckIn = false;
  int _selectedHour = 10;
  late DateTime _viewMonth;

  static DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isPast(DateTime day) => day.isBefore(_today);

  @override
  void initState() {
    super.initState();
    _checkIn = _today.add(const Duration(days: 1));
    _checkOut = _today.add(const Duration(days: 3));
    _viewMonth = DateTime(_today.year, _today.month);
  }

  static const _weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  static const _hours = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19];

  void _onDayTap(DateTime day) {
    if (_isPast(day)) return;
    setState(() {
      if (_pickingCheckIn || day.isBefore(_checkIn)) {
        _checkIn = day;
        _checkOut = day;
        _pickingCheckIn = false;
      } else if (day == _checkIn) {
        _pickingCheckIn = true;
      } else {
        _checkOut = day;
        _pickingCheckIn = false;
      }
    });
  }

  String _formatDate(DateTime d) {
    const months = [
      '', 'Th1', 'Th2', 'Th3', 'Th4', 'Th5', 'Th6',
      'Th7', 'Th8', 'Th9', 'Th10', 'Th11', 'Th12'
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month]}';
  }

  String _weekdayLabel(DateTime d) {
    const labels = ['', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return labels[d.weekday];
  }

  String _hourLabel(int h) => h < 12 ? '$h:00 SA' : '$h:00 CH';

  String get _summary {
    final ci = _formatDate(_checkIn);
    final co = _formatDate(_checkOut);
    final h = _hourLabel(_selectedHour);
    return '$ci – $co · $h';
  }

  int get _nights =>
      _checkOut.difference(_checkIn).inDays.abs().clamp(1, 999);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chọn ngày & Giờ',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.text),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildDateCards(),
                    const SizedBox(height: 20),
                    _buildCalendar(),
                    const SizedBox(height: 24),
                    const Text(
                      'Giờ nhận phòng',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text),
                    ),
                    const SizedBox(height: 12),
                    _buildTimeSlots(),
                    const SizedBox(height: 20),
                    _buildSummaryRow(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCards() {
    return Row(
      children: [
        Expanded(
          child: _DateCard(
            label: 'Nhận phòng',
            date: _formatDate(_checkIn),
            day: _weekdayLabel(_checkIn),
            selected: _pickingCheckIn,
            onTap: () => setState(() => _pickingCheckIn = true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DateCard(
            label: 'Trả phòng',
            date: _formatDate(_checkOut),
            day: _weekdayLabel(_checkOut),
            selected: !_pickingCheckIn,
            onTap: () => setState(() => _pickingCheckIn = false),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          _buildMonthHeader(),
          const SizedBox(height: 12),
          Row(
            children: _weekdays
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textGrey,
                                fontWeight: FontWeight.w500)),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          _buildDayGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    const monthNames = [
      '', 'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4',
      'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8',
      'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
    ];
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _viewMonth =
              DateTime(_viewMonth.year, _viewMonth.month - 1)),
          child: const Icon(Icons.chevron_left,
              color: AppColors.textGrey, size: 24),
        ),
        Expanded(
          child: Center(
            child: Text(
              '${monthNames[_viewMonth.month]} ${_viewMonth.year}',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _viewMonth =
              DateTime(_viewMonth.year, _viewMonth.month + 1)),
          child: const Icon(Icons.chevron_right,
              color: AppColors.textGrey, size: 24),
        ),
      ],
    );
  }

  Widget _buildDayGrid() {
    final firstDay = DateTime(_viewMonth.year, _viewMonth.month, 1);
    // weekday: 1=Mon, 7=Sun → offset to match T2..CN header
    final startOffset = (firstDay.weekday - 1) % 7;
    final daysInMonth =
        DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
    final totalCells =
        (startOffset + daysInMonth + 6) ~/ 7 * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: totalCells,
      itemBuilder: (_, i) {
        final dayNum = i - startOffset + 1;
        if (dayNum < 1 || dayNum > daysInMonth) {
          return const SizedBox();
        }
        final day =
            DateTime(_viewMonth.year, _viewMonth.month, dayNum);
        final past = _isPast(day);
        final isCheckIn = _isSameDay(day, _checkIn);
        final isCheckOut = _isSameDay(day, _checkOut);
        final inRange = day.isAfter(_checkIn) && day.isBefore(_checkOut);
        final isEndpoint = isCheckIn || isCheckOut;

        return GestureDetector(
          onTap: () => _onDayTap(day),
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: past
                  ? Colors.transparent
                  : isEndpoint
                      ? AppColors.primary
                      : inRange
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$dayNum',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isEndpoint ? FontWeight.w700 : FontWeight.normal,
                  color: past
                      ? AppColors.textLightGrey
                      : isEndpoint
                          ? Colors.white
                          : inRange
                              ? AppColors.primary
                              : AppColors.text,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _buildTimeSlots() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _hours.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final h = _hours[i];
          final active = _selectedHour == h;
          return GestureDetector(
            onTap: () => setState(() => _selectedHour = h),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: active
                        ? AppColors.primary
                        : AppColors.borderGrey),
              ),
              child: Text(
                _hourLabel(h),
                style: TextStyle(
                  fontSize: 12,
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

  Widget _buildSummaryRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined,
              color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _summary,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Đã chọn',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
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
              Text(
                '${widget.price}đ',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary),
              ),
              Text(
                '$_nights đêm',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textGrey),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GuestCountScreen(
                    propertyName: widget.propertyName,
                    location: widget.location,
                    imageUrl: widget.imageUrl,
                    price: widget.price,
                    checkIn: _checkIn,
                    checkOut: _checkOut,
                    nights: _nights,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 32),
              ),
              child: const Text('Tiếp tục',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),

          ),
        ],
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final String label;
  final String date;
  final String day;
  final bool selected;
  final VoidCallback onTap;

  const _DateCard({
    required this.label,
    required this.date,
    required this.day,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderGrey,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: selected
                        ? AppColors.primary
                        : AppColors.textGrey)),
            const SizedBox(height: 4),
            Text(date,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: selected ? AppColors.primary : AppColors.text)),
            Text(day,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }
}
