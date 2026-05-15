# Màn "Hồ sơ cá nhân" — Design Spec

**Date:** 2026-05-15
**Screen:** Tab "Cá nhân" (index 3) trong MainScreen
**File to create:** `lib/screens/profile_screen.dart`
**Stitch source:** `projects/14596441483209010574/screens/2454ba1943f34f91bf8ec468443c22b3`

---

## Exact Avatar Image (từ Stitch)
```
https://lh3.googleusercontent.com/aida-public/AB6AXuBM_BIDIDRz96tgpTBWgEMMS0-5dLQ33R2wE2vgv2MqLueM1xozDgQOz030YuE-cFCGMBYRXH_oIAXoACZrfhw8slh87nSL7CC6VlqMUmo9XqLAakfbSOzsMK_ZQLwoQ79ibS3i39I3Y6OQlBbKSDKS0-_5zD8Om8Dz5Y7Et2vE_Jfxqnbkem9Uf9OyaRpLXntkLntJx1BFkRwWW-tQORskxeNHKz8-HjK35ims7rIlC7qD8vrxdvJWogY1P9s1ctl2-R_oVTi-5aIz
```

---

## Layout

### AppBar
- Title: "Vietnam Explore", font w700 17px, color `#1A1A1A`
- Action: search icon
- Background: white, elevation 0

### Profile Header (padding 20px h, 24px top, 20px bottom)
- **Avatar**: `CachedNetworkImage`, circular (radius 40), URL trên
- **Name**: "Minh Anh Nguyễn", 20px, bold, `#1A1A1A`, marginTop 12px
- **Email**: "minhanh.traveler@email.com", 13px, `#757575`, marginTop 4px
- **Badge row** (marginTop 10px, spacing 8px):
  - Pill xanh: background `#EAF2EA`, text `#2D5A27`, 12px w600: "Nhà thám hiểm"
  - Pill xám: background `#F5F5F5`, text `#757575`, 12px: "12 Chuyến đi"
- **Nút Chỉnh sửa** (marginTop 14px): outlined, border `#2D5A27`, text `#2D5A27`, height 36px, border-radius 8px, padding h 20px, text 13px w500

### Divider section → padding h 20px, gap 12px giữa các card

### Menu Cards (4 items, mỗi card là Container white, border-radius 12px, padding 16px, shadow nhẹ)

**1. Lịch trình của tôi**
- Icon: `Icons.calendar_today_outlined`, background `#EAF2EA`, color `#2D5A27`
- Title: "Lịch trình của tôi", 15px w600, `#1A1A1A`
- Desc: "Xem lại các điểm đến đã lên kế hoạch và các chuyến đi đã hoàn thành.", 12px `#757575`
- Badge: Container `#EAF2EA`, "3 hành trình sắp tới", 11px w500 `#2D5A27`, border-radius 20px
- Trailing: `Icons.arrow_forward_ios`, size 14, color `#9E9E9E`

**2. Đánh giá**
- Icon: `Icons.star_outline`, background `#FFF8E1`, color `#F2994A`
- Title: "Đánh giá", 15px w600
- Desc: "Chia sẻ trải nghiệm của bạn về các điểm đến.", 12px `#757575`
- Trailing: Row của 5 `Icons.star_outline`, size 16, color `#FFC107`

**3. Cài đặt thông báo**
- Icon: `Icons.notifications_outlined`, background `#FFF3E0`, color `#F2994A`
- Title: "Cài đặt thông báo", 15px w600
- Desc: "Ưu đãi, nhắc nhở lịch trình & tin tức du lịch.", 12px `#757575`
- Trailing: `Switch`, value true (static), activeColor `#2D5A27`

**4. Ngôn ngữ**
- Icon: `Icons.language_outlined`, background `#E3F2FD`, color `#1565C0`
- Title: "Ngôn ngữ", 15px w600
- Desc: "Tiếng Việt", 12px `#757575`
- Trailing: `Icons.arrow_forward_ios`, size 14, color `#9E9E9E`

### Logout Button (margin h 20px, top 8px)
- `OutlinedButton.icon`, full width, height 48px
- Border: `#FFCDD2`, border-radius 12px
- Background: `#FFF5F5`
- Icon: `Icons.logout`, color `#E53935`, size 18px
- Text: "Đăng xuất", 15px w600, color `#E53935`

### Version text (center, bottom 16px)
- "Vietnam Explore v2.4.0", 11px, `#9E9E9E`

---

## Colors
- Primary green: `#2D5A27`
- Orange accent: `#F2994A`
- Error/Red: `#E53935`
- Text dark: `#1A1A1A`, grey: `#757575`, light grey: `#9E9E9E`

## Integration
- `main.dart`: thay `_PlaceholderScreen('Cá nhân')` → `ProfileScreen()`
- Import: `import 'screens/profile_screen.dart';`
