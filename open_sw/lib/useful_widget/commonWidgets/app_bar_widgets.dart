import 'dart:ui';
import 'package:flutter/material.dart';
import 'common_widgets.dart';

PreferredSizeWidget defaultAppBar() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: AppBar(
          backgroundColor: themePageColor.withAlpha(200),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
      ),
    ),
  );
}

PreferredSizeWidget searchAppBar({
  required TextEditingController controller,
  required Future<void> Function() onSearch,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight + 76),
    child: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: AppBar(
          backgroundColor: const Color(0xB0F2F2F2),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(76),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: padding_small, vertical: padding_small),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.orangeAccent,
                        controller: controller,
                        style: contentsNormal(),
                        decoration: const InputDecoration(
                          hintText: '모일 장소를 알려주세요',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                        onSubmitted: (_) => onSearch(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        await onSearch();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}


