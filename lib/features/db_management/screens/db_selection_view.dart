import 'package:firebase_browser/features/core/assets/icons/icons.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class DbSelectionView extends StatefulWidget {
  const DbSelectionView({super.key});

  @override
  State<DbSelectionView> createState() => _DbSelectionViewState();
}

class _DbSelectionViewState extends State<DbSelectionView> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final int crossAxisCount = max(1, size.width ~/ 300);
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * 0.25,
              child: Image.asset(AppIcons.firebaseHorizontalFull),
            ),
            Row(
              children: [
                Text(
                  "Available Databases",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Spacer(),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("+ Database"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).focusColor,
                ),
                child: GridView.builder(
                  itemCount: 2, // TODO: change
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 3,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 26,
                              child: Image.asset(AppIcons.firebaseIconMono),
                            ),
                            SizedBox(width: 8),
                            Text("bim-three-vue"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
