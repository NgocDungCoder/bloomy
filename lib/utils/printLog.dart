import 'package:flutter/material.dart';

void printLog({
  required String message,
  String tag = 'INFO',
  String type = 'info', // info, warning, error
  bool showBorder = true,
}) {
  // Mã màu ANSI
  const String reset = '\x1B[0m';
  const String green = '\x1B[32m';
  const String yellow = '\x1B[33m';
  const String red = '\x1B[31m';
  const String cyan = '\x1B[36m';

  // Chọn màu dựa trên type
  String color;
  switch (type.toLowerCase()) {
    case 'warning':
      color = yellow;
      break;
    case 'error':
      color = red;
      break;
    case 'info':
    default:
      color = green;
      break;
  }

  // Thời gian hiện tại
  final now = DateTime.now();
  final timestamp = '${now.hour}:${now.minute}:${now.second}.${now.millisecond}';

  // Định dạng tag
  final formattedTag = '[$tag]';

  // Định dạng thông điệp
  const maxWidth = 60; // Độ dài tối đa của mỗi dòng
  final lines = <String>[];
  final words = message.split(' ');
  String currentLine = '';

  for (var word in words) {
    if ((currentLine + word).length > maxWidth) {
      lines.add(currentLine.trim());
      currentLine = word + ' ';
    } else {
      currentLine += word + ' ';
    }
  }
  if (currentLine.isNotEmpty) {
    lines.add(currentLine.trim());
  }

  // Tạo khung
  final borderTopBottom = showBorder ? '═' * (maxWidth + 10) : '';
  final borderSide = showBorder ? '║' : '';

  // In log
  if (showBorder) {
    print('$cyan$borderTopBottom$reset');
    print('$cyan$borderSide$reset $timestamp $formattedTag $reset');
    print('$cyan$borderSide$reset');
  }

  for (var line in lines) {
    print('$cyan$borderSide$reset $color$line${' ' * (maxWidth - line.length)}$reset $cyan$borderSide$reset');
  }

  if (showBorder) {
    print('$cyan$borderSide$reset');
    print('$cyan$borderTopBottom$reset');
  }
}

// Ví dụ sử dụng
void main() {
  printLog(
    message: 'Đây là một thông điệp log thông thường.',
    tag: 'INFO',
    type: 'info',
  );

  printLog(
    message: 'Cảnh báo: Hệ thống đang gặp sự cố nhỏ, vui lòng kiểm tra lại.',
    tag: 'WARNING',
    type: 'warning',
  );

  printLog(
    message: 'Lỗi nghiêm trọng: Không thể kết nối đến server!',
    tag: 'ERROR',
    type: 'error',
  );

  printLog(
    message: 'Log không khung, dùng để debug nhanh.',
    tag: 'DEBUG',
    type: 'info',
    showBorder: false,
  );
}