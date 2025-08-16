#!/bin/bash

echo "🔍 Running Flutter checks..."
echo ""

echo "📊 Running static analysis..."
flutter analyze
if [ $? -ne 0 ]; then exit 1; fi

echo ""
echo "🎨 Formatting code..."
dart format .
if [ $? -ne 0 ]; then exit 1; fi

echo ""
echo "🧪 Running tests..."
flutter test
if [ $? -ne 0 ]; then exit 1; fi

echo ""
echo "✅ All checks passed!"