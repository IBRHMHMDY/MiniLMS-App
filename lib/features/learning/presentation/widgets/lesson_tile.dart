import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../domain/entities/lesson_entity.dart';

class LessonTile extends StatefulWidget {
  final LessonEntity lesson;

  const LessonTile({super.key, required this.lesson});

  @override
  State<LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<LessonTile> {
  YoutubePlayerController? _youtubeController;
  bool _hasValidVideo = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    // التحقق من وجود رابط الفيديو
    if (widget.lesson.videoUrl != null && widget.lesson.videoUrl!.isNotEmpty) {
      // استخراج الـ ID الخاص بالفيديو من الرابط أياً كان شكله
      final videoId = YoutubePlayer.convertUrlToId(widget.lesson.videoUrl!);

      if (videoId != null) {
        _hasValidVideo = true;
        // تهيئة المشغل (بدون تشغيل تلقائي للحفاظ على باقة المستخدم المادية)
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // تدمير المشغل عند إغلاق الشاشة أو تدمير العنصر لمنع تسرب الذاكرة (Memory Leak)
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // لضمان عدم خروج الفيديو عن حواف الـ Card
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.1),
          child: Text(
            widget.lesson.orderNumber.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          widget.lesson.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // يتم استدعاء ما بداخل الـ children فقط عندما يقوم المستخدم بتوسيع (Expand) العنصر
        children: [
          if (_hasValidVideo && _youtubeController != null)
            YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _youtubeController!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.red,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.redAccent,
                ),
                // إيقاف الفيديو مؤقتاً إذا قام المستخدم بتصغير الشاشة أو سحبها
                onReady: () {
                  // يمكن إضافة أحداث هنا عند جاهزية المشغل
                },
              ),
              builder: (context, player) {
                return Column(children: [player, _buildContentPadding()]);
              },
            )
          else
            _buildContentPadding(),
        ],
      ),
    );
  }

  // دالة مساعدة (Helper Method) لعرض المحتوى النصي الخاص بالدرس
  Widget _buildContentPadding() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_hasValidVideo &&
              widget.lesson.videoUrl != null &&
              widget.lesson.videoUrl!.isNotEmpty) ...[
            const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'رابط الفيديو غير صالح أو غير مدعوم.',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          if (widget.lesson.content != null &&
              widget.lesson.content!.isNotEmpty) ...[
            const Text(
              'محتوى الدرس:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              widget.lesson.content!,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ] else if (!_hasValidVideo) ...[
            // في حال لم يكن هناك فيديو ولا محتوى نصي
            const Center(
              child: Text(
                'لا يوجد محتوى متاح لهذا الدرس حالياً.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
