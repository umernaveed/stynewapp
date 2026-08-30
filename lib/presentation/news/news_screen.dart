import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/assets/drawables.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/data/models/news/news.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/news/news_controller.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class NewsScreen extends GetView<NewsController> {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showGradients: false,
      value: SystemUiOverlayStyle.dark,
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AuthCustomAppBar.withSmallAppLogo(
        backID: find<BottomNavController>().bottomNavNestedID,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => controller.pagingController.refresh(),
        ),
        child: PagedListView<int, News>.separated(
          padding: EdgeInsets.only(
            left: 4.2.w,
            right: 4.2.w,
            top: 1.4.h,
            bottom: 2.5.h,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          pagingController: controller.pagingController,
          scrollDirection: Axis.vertical,
          builderDelegate: PagedChildBuilderDelegate(
            animateTransitions: true,
            transitionDuration: 500.milliseconds,
            firstPageProgressIndicatorBuilder: (context) {
              return const _ShimmmerListView();
            },
            newPageProgressIndicatorBuilder: (context) {
              return const _ShimmmerListView();
            },
            itemBuilder: (context, item, index) {
              return _NewsItem(news: item);
            },
          ),
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
        ),
      ),
    );
  }
}

class _NewsItem extends StatelessWidget {
  const _NewsItem({required this.news});
  final News news;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.2.w, vertical: 1.6.h),
      width: context.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE4E8EA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: CachedNetworkImage(
              imageUrl: news.image,
              fit: BoxFit.cover,
              width: context.width,
              height: 25.h,
              placeholder: (context, url) => Image.asset(
                Drawables.emptyImage,
                fit: BoxFit.cover,
                width: context.width,
                height: 25.h,
              ),
              errorWidget: (context, url, error) => Image.asset(
                Drawables.emptyImage,
                fit: BoxFit.fill,
                width: context.width,
                height: 25.h,
              ),
            ),
          ),
          SizedBox(height: 1.2.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              news.title,
              textAlign: TextAlign.justify,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF090D1B),
                fontSize: 11.2.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            width: context.width,
            child: Html(
              data: news.newsDescription,
              shrinkWrap: true,
            ),
          ),
          // SizedBox(height: 1.h),
        ],
      ),
    );
  }
}

class _ShimmmerListView extends StatelessWidget {
  const _ShimmmerListView();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 4,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: 0.5.h),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return ShimmerWidget(
          height: 36.h,
          radius: BorderRadius.circular(17),
          child: const SizedBox.shrink(),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
    );
  }
}
