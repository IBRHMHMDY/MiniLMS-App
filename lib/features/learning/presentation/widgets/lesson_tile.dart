import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_lms_app/features/learning/domain/entities/lesson_entity.dart';
import 'package:mini_lms_app/features/learning/presentation/bloc/learning_bloc.dart';
import 'package:mini_lms_app/features/learning/presentation/bloc/learning_event.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class LessonTile extends StatefulWidget {
  final LessonEntity lesson;
  final int courseId;

  const LessonTile({super.key, required this.lesson, required this.courseId});

  @override
  State<LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<LessonTile> {
  YoutubePlayerController? _youtubeController;
  bool _hasValidVideo = false;
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
        )..addListener(_videoListener);
      }
    }
  }

  void _videoListener() {
    if (_youtubeController != null && _youtubeController!.value.isReady) {
      final position = _youtubeController!.value.position;
      final duration = _youtubeController!.metadata.duration;

      if (duration.inMilliseconds > 0 &&
          !widget.lesson.isCompleted &&
          !_isCompletionTriggered) {
        final percentage = position.inMilliseconds / duration.inMilliseconds;

        if (percentage >= 0.95) {
          _isCompletionTriggered = true;
          context.read<LearningBloc>().add(
            ToggleLessonCompletionEvent(lessonId: widget.lesson.id),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _youtubeController?.pause(); // 👈 منع الـ Memory leak في Audio Thread
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

          if (widget.lesson.quiz.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.quiz, color: Colors.white),
                  label: const Text(
                    'اختبر معلوماتك في هذا الدرس',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    final currentQuiz = widget.lesson.quiz.first;
                    // استخدام GoRouter مع تمرير الكائن بطريقة معمارية نظيفة
                    context.push(
                      '/course/${widget.courseId}/quiz',
                      extra: currentQuiz,
                    );
                  },
                ),
              ),
            ),
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
