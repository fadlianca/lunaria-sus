import 'package:flutter/material.dart';
import '../../services/youtube_video_service.dart';
import '../../widgets/cookie_counter.dart';
import 'package:provider/provider.dart';
import '../../providers/cookie_provider.dart';
import 'video_detail_screen.dart';
import '../../constants/app_colors.dart';

class VideoListScreen extends StatefulWidget {
  final String tag;
  const VideoListScreen({required this.tag, Key? key}) : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  List<Map<String, dynamic>> videos = [];
  bool loading = true;
  Set<String> unlocked = {}; // Video IDs
  Set<String> completed = {}; // Track completed video IDs

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    final fetched = await YoutubeVideoService.fetchVideosByTag(widget.tag);
    setState(() {
      videos = fetched;
      loading = false;
    });
  }

  void unlockVideo(String id) {
    final cookieProvider = Provider.of<CookieProvider>(context, listen: false);
    if (cookieProvider.spendCookies(30)) {
      setState(() {
        unlocked.add(id);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Video unlocked!')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Not enough cookies!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.tag,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Consumer<CookieProvider>(
              builder:
                  (context, cookieProvider, _) =>
                      CookieCounter(count: cookieProvider.cookies),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body:
          loading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final v in videos)
                    _VideoCard(
                      video: v,
                      isUnlocked: unlocked.contains(v['id']),
                      onUnlock: () => unlockVideo(v['id']),
                      onTap: () {
                        if (unlocked.contains(v['id'])) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => VideoDetailScreen(
                                    video: v,
                                    onComplete: () {
                                      if (!completed.contains(v['id'])) {
                                        Provider.of<CookieProvider>(
                                          context,
                                          listen: false,
                                        ).addCookies(10);
                                        setState(() {
                                          completed.add(v['id']);
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text('+10 cookies!'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                            ),
                          );
                        }
                      },
                    ),
                ],
              ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final Map video;
  final bool isUnlocked;
  final VoidCallback onUnlock;
  final VoidCallback onTap;
  const _VideoCard({
    required this.video,
    required this.isUnlocked,
    required this.onUnlock,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isUnlocked ? onTap : null,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    video['thumbnail'],
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video['title'],
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${video['channel']} | 30K views',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isUnlocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock, color: Colors.white, size: 40),
                        SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: onUnlock,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/cookie_icon.png',
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Unlock (30)',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
