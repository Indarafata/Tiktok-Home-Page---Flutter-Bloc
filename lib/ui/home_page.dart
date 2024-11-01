import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiktok_home_page_bloc/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiktok_home_page_bloc/data/comment_data.dart';
import 'package:tiktok_home_page_bloc/model/tiktok_model.dart';
import 'package:tiktok_home_page_bloc/service/tiktok_service.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(TiktokService())..add(LoadVideos()),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            toolbarHeight: 10,
          ),
          body: Stack(
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is HomeLoaded) {
                    return PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      itemCount: state.videos.length,
                      onPageChanged: (index) {
                        context.read<HomeBloc>().add(PlayVideo(index));
                      },
                      itemBuilder: (context, index) {
                        Tiktok videoData =
                            state.videos[index % state.videos.length];
                        return _buildVideoPage(
                            context, index, videoData, state.controllers);
                      },
                    );
                  } else if (state is HomeError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return const Center(
                      child: Text("No Data"),
                    );
                  }
                },
              ),
              _buildTopBar(),
            ],
          )),
    );
  }

  Widget _buildVideoPage(BuildContext context, int index, Tiktok videoData,
      List<VideoPlayerController> controllers) {
    return Stack(
      children: [
        controllers[index].value.isInitialized
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: VideoPlayer(controllers[index]),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black,
                child:const  Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        _builtRightSideBar(context, videoData),
        _buildCaption(videoData),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            "assets/icons/live-streaming.svg",
            height: 20,
            width: 20,
            color: Colors.white,
          ),
          const Text(
            "Friends",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const Text(
            "Following",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const Text(
            "For You",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCaption(Tiktok videoData) {
    return Positioned(
      bottom: 15,
      left: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            videoData.username!,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400),
          ),
          Text(
            videoData.caption!,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w300),
          )
        ],
      ),
    );
  }

  Widget _builtRightSideBar(BuildContext context, Tiktok videoData) {
    return Positioned(
      bottom: 15,
      right: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 43,
                height: 43,
                padding: const EdgeInsets.all(1.5),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: ClipOval(
                  child: Image.network(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjDWHDixicL1RC9UbcXlPGzcQmV9lw81L7UQ&s",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                  bottom: -5,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 12,
                    ),
                  ))
            ],
          ),
          const SizedBox(
            height: 13,
          ),
          const Icon(
            Icons.favorite,
            color: Colors.white,
            size: 30,
          ),
          Text(NumberFormat.compact().format(123456),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 13,
          ),
          GestureDetector(
            child: SvgPicture.asset(
              "assets/icons/message.svg",
              color: Colors.white,
              width: 28,
              height: 28,
            ),
            onHorizontalDragDown: (DragDownDetails) {
              showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.65,
                      color: Colors.grey[900],
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${NumberFormat('#,###').format(videoData.comment)} comments",
                                    style: TextStyle(
                                        color: Colors.grey[300],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  top: -10,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: commentData.length,
                              itemBuilder: (context, index) {
                                return _commentItem(
                                    commentData[index].urlPhotoProfile,
                                    commentData[index].username,
                                    commentData[index].comment,
                                    commentData[index].like,
                                    commentData[index].date);
                              },
                            ),
                          ),
                          Container(
                            height: 120,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: Image.asset(
                                          'assets/icons/smiling.png'),
                                    ),
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child:
                                          Image.asset('assets/icons/smile.png'),
                                    ),
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child:
                                          Image.asset('assets/icons/laugh.png'),
                                    ),
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: Image.asset(
                                          'assets/icons/surprised.png'),
                                    ),
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: Image.asset(
                                          'assets/icons/confident.png'),
                                    ),
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: Image.asset(
                                          'assets/icons/happy-face.png'),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      child: ClipOval(
                                        child: Image.network(
                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjDWHDixicL1RC9UbcXlPGzcQmV9lw81L7UQ&s",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "Add comment...",
                                                    hintStyle: TextStyle(
                                                        color:
                                                            Colors.grey[400])),
                                              ),
                                            ),
                                            Icon(
                                              Icons.alternate_email,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              Icons.emoji_emotions,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              Icons.card_giftcard,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  });
            },
          ),
          Text(NumberFormat.compact().format(123456),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 13,
          ),
          const Icon(
            Icons.bookmark,
            color: Colors.white,
            size: 30,
          ),
          Text(NumberFormat.compact().format(123456),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 13,
          ),
          SvgPicture.asset("assets/icons/share.svg",
              color: Colors.white, width: 28, height: 28),
          Text(NumberFormat.compact().format(123456),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 13,
          ),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: const RotatingImage(),
          )
        ],
      ),
    );
  }

  Widget _commentItem(String urlPhotoProfile, String username, String comment,
      String like, String date) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 38,
                    width: 38,
                    child: ClipOval(
                      child: Image.network(
                        urlPhotoProfile,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          comment,
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(date,
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 12)),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Reply",
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                           const  Spacer(),
                            SvgPicture.asset(
                              "assets/icons/love.svg",
                              height: 15,
                              width: 15,
                              color: Colors.grey[400],
                            ),
                           const  SizedBox(width: 5),
                            Text(
                              like,
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 12),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            SvgPicture.asset(
                              "assets/icons/dislike.svg",
                              height: 15,
                              width: 15,
                              color: Colors.grey[400],
                            ),
                          ],
                        )
                      ],
                    ),
                  ))
                ],
              )
            ],
          ),
        ))
      ],
    );
  }
}

class RotatingImage extends StatefulWidget {
  const RotatingImage({super.key});

  @override
  State<RotatingImage> createState() => _RotatingImageState();
}

class _RotatingImageState extends State<RotatingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: RotationTransition(
        turns: _controller.drive(Tween(begin: 0, end: 1)),
        child: ClipOval(
          child: Image.network(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjDWHDixicL1RC9UbcXlPGzcQmV9lw81L7UQ&s",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
