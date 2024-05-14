import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:venus/src/utils/constants/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ListVideoMobile extends StatelessWidget {
  const ListVideoMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: const Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Truyền thông nói gì?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            ListVideoView(),
          ],
        ),
      ),
    );
  }
}

class Video extends Equatable {
  const Video({
    required this.id,
    this.title,
    this.link,
    this.thumbnail,
  });

  final String id;
  final String? title;
  final String? link;
  final String? thumbnail;

  static const empty = Video(id: '');
  bool get isEmpty => this == Video.empty;
  bool get isNotEmpty => this != Video.empty;

  @override
  List<Object?> get props => [id, title, link, thumbnail];
}

const List<Video> videos = <Video>[
  Video(
    id: "uqEsplOSXJc",
    title: "AI đã thay đổi ngành nha như thế nào?",
    link: 'https://youtu.be/uqEsplOSXJc',
    thumbnail:
        "https://aismile.com.vn/wp-content/uploads/2023/10/maxresdefault-1-jpg.webp",
  ),
  Video(
    id: "jYw79YGsF18",
    title:
        "THẠC SĨ - BÁC SĨ NGUYỄN NGỌC HẢI - TRÍ TUỆ NHÂN TẠO VÀ NỖ LỰC CHĂM SÓC NỤ CƯỜI",
    link: 'https://youtu.be/jYw79YGsF18',
    thumbnail:
        "https://aismile.com.vn/wp-content/uploads/2023/10/THUMB-WEB-1920X1080px-3-1-jpg.webp",
  ),
  Video(
    id: "9Y4zcE7-vCw",
    title:
        "HTV9 - NIỀNG RĂNG TRONG SUỐT AISMILE – GIẢI PHÁP MỚI CHO NGÀNH NHA KHOA THẨM MỸ",
    link: 'https://youtu.be/9Y4zcE7-vCw',
    thumbnail:
        "https://aismile.com.vn/wp-content/uploads/2023/10/THUMB-WEB-1920X1080px-3-1-jpg.webp",
  ),
];

class ListVideoView extends StatelessWidget {
  const ListVideoView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 248,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 254,
                  height: 142,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: InkWell(
                            onTap: () {
                              showDialog<Widget>(
                                  context: context,
                                  useSafeArea: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      insetPadding: const EdgeInsets.all(16),
                                      contentPadding: const EdgeInsets.all(0),
                                      content: VideoPlayerPopUp(
                                          id: videos[index].id, autoPlay: true),
                                    );
                                  });
                            },
                            child: SizedBox(
                              child: Stack(
                                children: [
                                  Image.network(videos[index].thumbnail ?? "",
                                      height: 142,
                                      width: 238,
                                      fit: BoxFit.cover),
                                  Positioned(
                                      top: (142 - 40) / 2,
                                      left: (238 - 40) / 2,
                                      child: SvgPicture.asset(
                                          "assets/icons/play.svg",
                                          width: 40,
                                          height: 40))
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 24, 0),
                          child: Text(videos[index].title ?? "",
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        )
                      ]),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class VideoPlayerPopUp extends StatelessWidget {
  const VideoPlayerPopUp({super.key, required this.id, required this.autoPlay});

  final String id;
  final bool autoPlay;

  @override
  Widget build(BuildContext context) {
    final YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: id,
      flags: YoutubePlayerFlags(
        autoPlay: autoPlay,
        mute: false,
      ),
    );

    return Material(
      color: TColors.white,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.width - 32) * 9 / 16,
          child: YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            progressColors: ProgressBarColors(
              playedColor: TColors.primary,
              handleColor: TColors.primary.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}
