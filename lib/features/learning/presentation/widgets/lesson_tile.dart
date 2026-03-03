import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../domain/entities/lesson_entity.dart';
import '../bloc/learning_bloc.dart';
import '../bloc/learning_event.dart';

class LessonTile extends StatefulWidget {
  final LessonEntity lesson;

  const LessonTile({super.key, required this.lesson});

  @override
  State<LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<LessonTile> {
  YoutubePlayerController? _youtubeController;
  bool _hasValidVideo = false;

  // علم الحماية (Flag) لمنع إرسال طلبات متعددة للسيرفر عند وصول الفيديو لـ 90%
  bool _isCompletionTriggered = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    if (widget.lesson.videoUrl != null && widget.lesson.videoUrl!.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(widget.lesson.videoUrl!);

      if (videoId != null) {
        _hasValidVideo = true;
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
          ),
        )..addListener(_videoListener); // 👈 ربط المستمع (Listener) هنا
      }
    }
  }

  // العقل المدبر للتتبع التلقائي
  void _videoListener() {
    if (_youtubeController != null && _youtubeController!.value.isReady) {
      final position = _youtubeController!.value.position;
      final duration = _youtubeController!.metadata.duration;

      // التأكد من أن الفيديو له مدة، وأن الدرس لم يكتمل بعد، وأنه لم نقم بإرسال الطلب مسبقاً
      if (duration.inMilliseconds > 0 &&
          !widget.lesson.isCompleted &&
          !_isCompletionTriggered) {
        final percentage = position.inMilliseconds / duration.inMilliseconds;

        // إذا شاهد الطالب 90% من الفيديو
        if (percentage >= 0.90) {
          _isCompletionTriggered = true; // إغلاق البوابة لمنع تكرار الطلب

          // إرسال طلب التحديث للسيرفر بصمت (سيتحول لون الأيقونة للأخضر تلقائياً)
          context.read<LearningBloc>().add(
            ToggleLessonCompletionEvent(lessonId: widget.lesson.id),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _youtubeController?.removeListener(_videoListener);
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        // استبدال الـ Checkbox بأيقونة غير قابلة للضغط (لأن التتبع أصبح تلقائياً)
        leading: Icon(
          widget.lesson.isCompleted
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: widget.lesson.isCompleted ? Colors.green : Colors.grey,
          size: 28,
        ),
        title: Text(
          widget.lesson.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // شطب النص وتغيير لونه إذا كان الدرس مكتملاً
            decoration: widget.lesson.isCompleted
                ? TextDecoration.lineThrough
                : null,
            color: widget.lesson.isCompleted
                ? Colors.grey.shade700
                : Colors.black,
          ),
        ),
        children: [
          if (_hasValidVideo && _youtubeController != null)
            YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _youtubeController!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Theme.of(context).colorScheme.primary,
                progressColors: ProgressBarColors(
                  playedColor: Theme.of(context).colorScheme.primary,
                  handleColor: Theme.of(context).colorScheme.secondary,
                ),
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
                    'رابط الفيديو غير صالح.',
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
            const Center(
              child: Text(
                'لا يوجد محتوى متاح.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],

          // ذكاء برمجي: زر يدوي يظهر فقط للدروس النصية (التي لا تحتوي على فيديو)
          if (!_hasValidVideo && !widget.lesson.isCompleted) ...[
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<LearningBloc>().add(
                    ToggleLessonCompletionEvent(lessonId: widget.lesson.id),
                  );
                },
                icon: const Icon(Icons.check),
                label: const Text('لقد أنهيت قراءة هذا الدرس'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
