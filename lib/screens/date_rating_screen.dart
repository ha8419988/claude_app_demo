import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class DateRatingScreen extends StatefulWidget {
  const DateRatingScreen({super.key});

  @override
  State<DateRatingScreen> createState() => _DateRatingScreenState();
}

class _DateRatingScreenState extends State<DateRatingScreen> {
  int _faceScore = 5;
  int _personalityScore = 5;
  int _behaviorScore = 5;
  int _styleScore = 2;
  int _premeScore = 0;
  int _dateScore = 0;

  final Set<String> _faceChecked = {};
  final Set<String> _personalityChecked = {};
  final Set<String> _behaviorChecked = {};

  final _goodPointCtrl = TextEditingController();
  final _badPointCtrl = TextEditingController();
  final _discrepancyCtrl = TextEditingController();

  static const _faceItems = [
    '目がぱっちり',
    '鼻筋',
    '小鼻',
    'ぷっくりした唇',
    '歯並び',
    'えくぼ',
    '笑顔',
    '小さい顔',
    '丸顔',
    '肌',
    '色白',
    'ロングヘア',
    'ショートヘア',
    '黒髪',
    '髪が綺麗',
    'グラマー',
    '色気',
    '手が綺麗',
    'ファッション',
    'その他',
  ];

  static const _personalityItems = [
    '優しい',
    '明るい',
    '面白い',
    '知的',
    '話題が豊富',
    '聞き上手',
    '褒め上手',
    '誠実',
    '情熱的',
    '落ち着きがある',
    '好奇心旺盛',
    '仕事好き',
    '天然',
    'その他',
  ];

  static const _behaviorItems = [
    '礼儀正しい',
    '面倒見がいい',
    '遅刻をしない',
    'テーブルマナー',
    '姿勢がいい',
    '所作が美しい',
    '声が綺麗',
    'その他',
  ];

  @override
  void dispose() {
    _goodPointCtrl.dispose();
    _badPointCtrl.dispose();
    _discrepancyCtrl.dispose();
    super.dispose();
  }

  void _toggle(Set<String> set, String s) =>
      setState(() => set.contains(s) ? set.remove(s) : set.add(s));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const _DateRatingAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _sectionWithCheckboxes(
              title: '顔/容姿',
              subtitle: 'どんな点が良かったですか？',
              slider: _TenPointSlider(
                value: _faceScore,
                onChanged: (v) => setState(() => _faceScore = v),
              ),
              items: _faceItems,
              checked: _faceChecked,
              onToggle: (s) => _toggle(_faceChecked, s),
            ),
            _sectionWithCheckboxes(
              title: '性格/会話',
              subtitle: 'どんな点が良かったですか？',
              slider: _TenPointSlider(
                value: _personalityScore,
                onChanged: (v) => setState(() => _personalityScore = v),
              ),
              items: _personalityItems,
              checked: _personalityChecked,
              onToggle: (s) => _toggle(_personalityChecked, s),
            ),
            _sectionWithCheckboxes(
              title: '振る舞い/マナー',
              subtitle: 'どんな点がよかったですか？',
              slider: _TenPointSlider(
                value: _behaviorScore,
                onChanged: (v) => setState(() => _behaviorScore = v),
              ),
              items: _behaviorItems,
              checked: _behaviorChecked,
              onToggle: (s) => _toggle(_behaviorChecked, s),
            ),
            _simpleSection(
              title: 'スタイル',
              child: _LabeledSlider(
                labels: const ['細い', 'スリム', '普通', 'ぽっちゃり', '太い'],
                selected: _styleScore,
                onChanged: (v) => setState(() => _styleScore = v),
              ),
            ),
            _simpleSection(
              title: 'Preme会員としてふさわしいか',
              child: _LabeledSlider(
                labels: const ['◆', '1', '2', '3', '4', '5'],
                selected: _premeScore,
                onChanged: (v) => setState(() => _premeScore = v),
              ),
            ),
            _simpleSection(
              title: '本日のお相手とまたデートに行きたいと思いますか？',
              child: _LabeledSlider(
                labels: const [
                  '◆',
                  '12123213232323',
                  'あまり行き\nたくない',
                  '誘われたら\n行きたい',
                  '是非\n行きたい',
                ],
                selected: _dateScore,
                onChanged: (v) => setState(() => _dateScore = v),
              ),
            ),
            const SizedBox(height: 8),
            _textField('特に良かった点をご記入ください(任意)', _goodPointCtrl),
            const SizedBox(height: 16),
            _textField('特に悪かった点をご記入ください(任意)', _badPointCtrl),
            const SizedBox(height: 16),
            _textField('事前情報に相違があった場合、ご記入ください', _discrepancyCtrl),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  elevation: 0,
                ),
                child: Text(
                  'AIに学習させる',
                  style: GoogleFonts.notoSansJp(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionWithCheckboxes({
    required String title,
    required String subtitle,
    required Widget slider,
    required List<String> items,
    required Set<String> checked,
    required ValueChanged<String> onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title),
        const SizedBox(height: 16),
        slider,
        const SizedBox(height: 16),
        _RequiredLabel(text: subtitle),
        const SizedBox(height: 12),
        _CheckboxGrid(items: items, checked: checked, onToggle: onToggle),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _simpleSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title),
        const SizedBox(height: 16),
        child,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _textField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.notoSansJp(
            color: AppColors.text,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          style: GoogleFonts.notoSansJp(color: AppColors.text, fontSize: 15),
          decoration: InputDecoration(
            hintText: '全角500文字まで',
            hintStyle: GoogleFonts.notoSansJp(
              color: AppColors.greyArrow,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            isDense: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.greyArrow),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.greyArrow),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── AppBar ───────────────────────────────────────────────────────────────────

class _DateRatingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DateRatingAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 40,
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading:
          const Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 24),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'AI学習シート',
            style: GoogleFonts.notoSansJp(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.help, size: 13, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            title,
            style: GoogleFonts.notoSansJp(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          color: const Color(0xFFB00A0A),
          child: Text(
            '必須',
            style: GoogleFonts.notoSansJp(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  final String text;
  const _RequiredLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: GoogleFonts.notoSansJp(
            color: AppColors.text,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          color: const Color(0xFFB00A0A),
          child: Text(
            '必須',
            style: GoogleFonts.notoSansJp(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── 10-Point Slider ──────────────────────────────────────────────────────────

class _TenPointSlider extends StatelessWidget {
  final int value; // 1–10
  final ValueChanged<int> onChanged;

  const _TenPointSlider({required this.value, required this.onChanged});

  int get _selectedIdx => value <= 5 ? value - 1 : value;

  static int _idxToValue(int i) => i < 5 ? i + 1 : i;

  int _xToValue(double x, double totalWidth) {
    // 11 visual elements, idx 5 là ◆ (không chọn được)
    final lineWidth = (totalWidth - 11 * 20.0) / 10.0;
    int bestIdx = 0;
    double bestDist = double.infinity;
    for (int i = 0; i <= 10; i++) {
      if (i == 5) continue;
      final center = 10.0 + i * (20.0 + lineWidth);
      final dist = (x - center).abs();
      if (dist < bestDist) {
        bestDist = dist;
        bestIdx = i;
      }
    }
    return _idxToValue(bestIdx);
  }

  @override
  Widget build(BuildContext context) {
    final sel = _selectedIdx;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        void handleX(double x) {
          final v = _xToValue(x.clamp(0.0, totalWidth), totalWidth);
          if (v != value) onChanged(v);
        }

        final railChildren = <Widget>[];
        final labelChildren = <Widget>[];

        for (int i = 0; i <= 10; i++) {
          if (i > 0) {
            final filled = (i - 1) < sel;
            railChildren.add(Expanded(
              child: Container(
                height: 6,
                color: filled ? AppColors.primary : AppColors.greyBorder,
              ),
            ));
            labelChildren.add(const Expanded(child: SizedBox()));
          }

          if (i == 5) {
            railChildren.add(_diamondWidget());
            labelChildren.add(_labelBox('◆', 12));
          } else {
            final filled = i <= sel;
            railChildren.add(_Dot(filled: filled));
            labelChildren.add(_labelBox(_idxToValue(i).toString(), 12));
          }
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => handleX(d.localPosition.dx),
          onHorizontalDragStart: (d) => handleX(d.localPosition.dx),
          onHorizontalDragUpdate: (d) => handleX(d.localPosition.dx),
          child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: railChildren),
              const SizedBox(height: 4),
              Row(children: labelChildren),
            ],
          ),
        );
      },
    );
  }
}

Widget _diamondWidget() {
  return SizedBox(
    width: 20,
    height: 20,
    child: Center(
      child: Text(
        '◆',
        style: GoogleFonts.notoSansJp(
          color: AppColors.primary,
          fontSize: 14,
        ),
      ),
    ),
  );
}

Widget _labelBox(String text, double fontSize) {
  return SizedBox(
    width: 20,
    child: Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSansJp(
          color: const Color(0x99202020),
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

// ─── Labeled Slider (スタイル / Preme / Date intention) ───────────────────────

class _LabeledSlider extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  const _LabeledSlider({
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  int _xToIndex(double x, double totalWidth) {
    final n = labels.length;
    if (n <= 1) return 0;
    final lineWidth = (totalWidth - n * 20.0) / (n - 1);
    int best = 0;
    double bestDist = double.infinity;
    for (int i = 0; i < n; i++) {
      final center = 10.0 + i * (20.0 + lineWidth);
      final dist = (x - center).abs();
      if (dist < bestDist) {
        bestDist = dist;
        best = i;
      }
    }
    return best.clamp(0, n - 1);
  }

  @override
  Widget build(BuildContext context) {
    final n = labels.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        void handleX(double x) {
          final idx = _xToIndex(x.clamp(0.0, totalWidth), totalWidth);
          if (idx != selected) onChanged(idx);
        }

        final railChildren = <Widget>[];
        final labelChildren = <Widget>[];

        for (int i = 0; i < n; i++) {
          if (i > 0) {
            final filled = (i - 1) < selected;
            railChildren.add(Expanded(
              child: Container(
                height: 6,
                color: filled ? AppColors.primary : AppColors.greyBorder,
              ),
            ));
            labelChildren.add(const Expanded(child: SizedBox()));
          }

          final isDiamond = labels[i] == '◆';
          final filled = i <= selected;

          railChildren.add(
            isDiamond ? _diamondWidget() : _Dot(filled: filled),
          );

          labelChildren.add(SizedBox(
            width: 20,
            height: 36,
            child: OverflowBox(
              minWidth: 20,
              maxWidth: 62,
              minHeight: 0,
              maxHeight: 36,
              alignment: Alignment.topCenter,
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansJp(
                  color: const Color(0x99202020),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
          ));
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => handleX(d.localPosition.dx),
          onHorizontalDragStart: (d) => handleX(d.localPosition.dx),
          onHorizontalDragUpdate: (d) => handleX(d.localPosition.dx),
          child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: railChildren),
              const SizedBox(height: 6),
              Row(children: labelChildren),
            ],
          ),
        );
      },
    );
  }
}

// ─── Dot ──────────────────────────────────────────────────────────────────────

class _Dot extends StatelessWidget {
  final bool filled;
  const _Dot({required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? AppColors.primary : Colors.white,
        border: Border.all(
          color: filled ? AppColors.primary : AppColors.greyBorder,
        ),
      ),
    );
  }
}

// ─── Checkbox Grid ────────────────────────────────────────────────────────────

class _CheckboxGrid extends StatelessWidget {
  final List<String> items;
  final Set<String> checked;
  final ValueChanged<String> onToggle;

  const _CheckboxGrid({
    required this.items,
    required this.checked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i += 2)
          Row(
            children: [
              Expanded(
                child: _CheckboxItem(
                  label: items[i],
                  checked: checked.contains(items[i]),
                  onToggle: () => onToggle(items[i]),
                ),
              ),
              if (i + 1 < items.length)
                Expanded(
                  child: _CheckboxItem(
                    label: items[i + 1],
                    checked: checked.contains(items[i + 1]),
                    onToggle: () => onToggle(items[i + 1]),
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),
      ],
    );
  }
}

class _CheckboxItem extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onToggle;

  const _CheckboxItem({
    required this.label,
    required this.checked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: checked ? AppColors.primary : Colors.white,
                border: Border.all(
                  color: checked ? AppColors.primary : AppColors.greyBorder,
                ),
              ),
              child: checked
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.notoSansJp(
                  color: AppColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
