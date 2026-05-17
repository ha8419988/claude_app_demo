#!/bin/bash
set -e

BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "🚀 Pushing branch: $BRANCH"
git commit --allow-empty -m "ci: trigger deploy [skip test]" 2>/dev/null || true
git push origin "$BRANCH"

echo ""
echo "⏳ Đợi GitHub Actions khởi động..."
sleep 8

RUN_ID=$(gh run list --branch "$BRANCH" --limit 1 --json databaseId --jq '.[0].databaseId')

if [ -z "$RUN_ID" ]; then
  echo "❌ Không tìm thấy CI run. Vào xem thủ công:"
  echo "   https://github.com/ha8419988/claude_app_demo/actions"
  exit 1
fi

echo "📋 Run ID: $RUN_ID"
echo "🔗 Link: https://github.com/ha8419988/claude_app_demo/actions/runs/$RUN_ID"
echo ""
echo "⏳ Đang chờ CI chạy xong (có thể mất 5-10 phút)..."
echo ""

# Theo dõi với timeout 15 phút
if gh run watch "$RUN_ID" --exit-status --interval 10; then
  echo ""
  echo "✅ CI/CD hoàn thành! APK đã upload lên DeployGate."
  echo "🔗 Xem tại: https://deploygate.com"
else
  CONCLUSION=$(gh run view "$RUN_ID" --json conclusion --jq '.conclusion')
  if [ "$CONCLUSION" = "success" ]; then
    echo ""
    echo "✅ CI/CD hoàn thành! APK đã upload lên DeployGate."
    echo "🔗 Xem tại: https://deploygate.com"
  else
    echo ""
    echo "❌ CI/CD thất bại! Log lỗi:"
    gh run view "$RUN_ID" --log-failed 2>/dev/null | grep -A 10 "Response body:" | head -15
    echo ""
    echo "🔗 Xem chi tiết: https://github.com/ha8419988/claude_app_demo/actions/runs/$RUN_ID"
    exit 1
  fi
fi
