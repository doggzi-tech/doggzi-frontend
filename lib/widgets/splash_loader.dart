import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/colors.dart';
import 'custom_loader.dart';

class SplashLoader extends StatelessWidget {
  const SplashLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 150.h),
          const Expanded(
            child: Center(
              child: CustomLoader(
                color: AppColors.orange400,
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/images/doggzi_logo.svg',
          ),
          SizedBox(height: 150.h),
        ],
      ),
    );
  }
}
