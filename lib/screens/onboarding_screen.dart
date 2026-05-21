import 'package:flutter/material.dart';
import 'package:claude_app_demo/core/routes/app_routes.dart';
import 'package:claude_app_demo/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingPage {
  final String image1Url;
  final String image2Url;
  final String title;
  final String titleAccent;
  final String description;

  const _OnboardingPage({
    required this.image1Url,
    required this.image2Url,
    required this.title,
    required this.titleAccent,
    required this.description,
  });
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      image1Url:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCZdHtzmUU4FuShJi4mOckI3w3_RkFbnSxwhAmrkFKSBD-F26NIcrXXBlt6pv3o3PCLv5fKpCjtGcdpssknQB6ZqB3DJ3OeHoi9uSD8bktDbBFDkuzff-cXHpEJPN8G-vD6o9JYpi1QJfmmkYsMKPzmkmGXzELKUVP_OUWDxzqpTvx9QQXqG2qoNQSjceEOVyegrD5eo-jzSf1_6SPgyX-6ENGurai5yrk2cMIUJte06PuWvZ7ZMcS90sc4sUuAcUfkAJMZTxmo9ME',
      image2Url:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCXzRhuxVmZqSKoWE3NPQIRyPDqweIcScwRl8OArspOkOLk0pu3fY5CM_f8WHGKUm3fa1TWf2haQNSWX-EK8o80iU2x0kUJ9Op3vcf7C7MIZefEvFPLIHrf1-B9gQvZUQsBuhNVt0L50GjkfydfXcIVKzEhnWcVKITA7RjegoHz__6DqQs2INOK-NVXokrSTjK6tgtDiYIrc9uOavrxeXcZfNc_0_RKvPPqYJp91k2OxxNGdBRTyOD5T1nsRAqWBhtgBu_b8Kwu5cU',
      title: 'Khám Phá Những',
      titleAccent: 'Điểm Đến',
      description:
          'Khám phá những viên ngọc ẩn của Việt Nam, từ núi non sương mù đến những bờ biển chan hòa nắng vàng.',
    ),
    _OnboardingPage(
      image1Url:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCCkczmB1kH01mU8Pn_HSw57mQBIfYVgX6KlZWj7xv8qHVvr8setUMiNCTZFPlYm2TMfpjbj6fv0wfb2SfZw5pfBO44lwXwyPKEgS7X0kgZp5qoRoOXfTLpvQ4HemceioP7tCo1fdWw6UJZjTSJGatRZ_AqWzEPr_AV8FcUAGYZH0cI9uN64uakwWzfaIlJKZ3FjQr-66eKrCS_Tv1tRnGtkxXSo6j1thlLXHwYLRFWqob_NbsM3vmGxjcmGlW7RE1u-5BGK9ADTJk',
      image2Url:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCyDvSmJDYe9qotx0TSx9Ogb1zHXudO-1J4rK8stslzegCmtcafJoG0j3p4mClbSQJUk3_szZzTKKUcwFs9Lk1M943hUIxOMc49Yko0aJNVsbYYCCIms8V5IWnfk7TJAUScjbJ3lTFJ2-BsRXNhMrA96VqSq75ldv2TWtNU-AtkbCkEoo3NdwUNphHHTzlfiQaC7TubPlI53_EC5XyZMRBJKEmLtZIHa6d8qQ548dCnRJaUmhvw5B0UkHFmHzkKOo9dHV_-djzXVP0',
      title: 'Đặt',
      titleAccent: 'Chỗ Nghỉ',
      description:
          'Chúng tôi ở đây để giúp bạn du lịch khắp nơi một cách an toàn với những trải nghiệm cao cấp.',
    ),
    _OnboardingPage(
      image1Url:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCyDvSmJDYe9qotx0TSx9Ogb1zHXudO-1J4rK8stslzegCmtcafJoG0j3p4mClbSQJUk3_szZzTKKUcwFs9Lk1M943hUIxOMc49Yko0aJNVsbYYCCIms8V5IWnfk7TJAUScjbJ3lTFJ2-BsRXNhMrA96VqSq75ldv2TWtNU-AtkbCkEoo3NdwUNphHHTzlfiQaC7TubPlI53_EC5XyZMRBJKEmLtZIHa6d8qQ548dCnRJaUmhvw5B0UkHFmHzkKOo9dHV_-djzXVP0',
      image2Url:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCCkczmB1kH01mU8Pn_HSw57mQBIfYVgX6KlZWj7xv8qHVvr8setUMiNCTZFPlYm2TMfpjbj6fv0wfb2SfZw5pfBO44lwXwyPKEgS7X0kgZp5qoRoOXfTLpvQ4HemceioP7tCo1fdWw6UJZjTSJGatRZ_AqWzEPr_AV8FcUAGYZH0cI9uN64uakwWzfaIlJKZ3FjQr-66eKrCS_Tv1tRnGtkxXSo6j1thlLXHwYLRFWqob_NbsM3vmGxjcmGlW7RE1u-5BGK9ADTJk',
      title: 'Tìm Kiếm',
      titleAccent: 'Địa Điểm Mới',
      description:
          'Chúng tôi ở đây để giúp bạn du lịch an toàn và khám phá những viên ngọc ẩn mà bạn chưa từng thấy.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() => _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

  void _skip() => Navigator.pushReplacementNamed(context, AppRoutes.login);

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 16),
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    'Bỏ qua',
                    style: TextStyle(
                      color: AppColors.text.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _PageBody(page: _pages[i]),
              ),
            ),

            // Dots
            _DotIndicator(count: _pages.length, current: _currentPage),
            const SizedBox(height: 32),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: isLast
                  ? Column(
                      children: [
                        _PrimaryButton(
                          label: 'Đăng nhập',
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, AppRoutes.login),
                        ),
                        const SizedBox(height: 12),
                        _OutlineButton(
                          label: 'Tạo tài khoản',
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, AppRoutes.register),
                        ),
                      ],
                    )
                  : _PrimaryButton(
                      label: 'Tiếp theo',
                      onPressed: _nextPage,
                    ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _PageBody extends StatelessWidget {
  final _OnboardingPage page;
  const _PageBody({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Image cards
          SizedBox(
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Left card (tilted back)
                Positioned(
                  left: 0,
                  top: 20,
                  child: Transform.rotate(
                    angle: -0.08,
                    child: _ImageCard(
                      url: page.image1Url,
                      width: 180,
                      height: 220,
                    ),
                  ),
                ),
                // Right card (tilted front)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Transform.rotate(
                    angle: 0.06,
                    child: _ImageCard(
                      url: page.image2Url,
                      width: 180,
                      height: 220,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          // Accent badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              page.titleAccent,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text.withValues(alpha: 0.6),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  const _ImageCard({required this.url, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFE8E0D8),
          );
        },
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: const Color(0xFFE8E0D8),
        ),
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int count;
  final int current;
  const _DotIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _OutlineButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
