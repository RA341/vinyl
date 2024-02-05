import 'package:audio_service/audio_service.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player_interface.g.dart';

const eMessage =
    'You forgot to initialize Vinyl\nCall "Vinyl.init()" in main.dart';

enum ButtonState {
  paused,
  playing,
  loading,
}

class ProgressBarState {
  const ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });

  final Duration current;
  final Duration buffered;
  final Duration total;

  ProgressBarState copyWith({
    Duration? current,
    Duration? buffered,
    Duration? total,
  }) {
    return ProgressBarState(
      current: current ?? this.current,
      buffered: buffered ?? this.buffered,
      total: total ?? this.total,
    );
  }
}

/// Store media information here
@JsonSerializable()
class MediaRecord {
  MediaRecord({
    required this.id,
    required this.title,
    required this.mediaUri,
    this.mediaHeaders,
    this.duration,
    this.artHeaders,
    this.artUri,
    this.artist,
    this.displaySubtitle,
    this.displayTitle,
    this.displayDescription,
    this.album,
    this.extras,
  });

  factory MediaRecord.fromJson(Map<String, dynamic> json) =>
      _$MediaRecordFromJson(json);

  Map<String, dynamic> toJson() => _$MediaRecordToJson(this);
  final String id;

  /// store media url can be file or web
  final String mediaUri;

  final String title;

  /// headers for the media file
  final Map<String, String>? mediaHeaders;

  final Duration? duration;

  final Map<String, String>? artHeaders;
  final String? artUri;
  final String? artist;
  final String? displaySubtitle;
  final String? displayTitle;
  final String? displayDescription;
  final String? album;
  final Map<String, dynamic>? extras;

  /// convert media record to media
}

class MediaRecordKeys {
  static const String id = 'id';
  static const String title = 'title';
  static const String album = 'album';
  static const String artHeaders = 'artHeaders';
  static const String artist = 'artist';
  static const String artUri = 'artUri';
  static const String displayDescription = 'displayDescription';
  static const String displaySubtitle = 'displaySubtitle';
  static const String displayTitle = 'displayTitle';
  static const String duration = 'duration';
  static const String extras = 'extras';
  static const String genre = 'genre';
  static const String playable = 'playable';
  static const String rating = 'rating';
  static const String mediaUri = 'mediaUri';
  static const String mediaHeaders = 'mediaHeaders';
}

/// Define default metadata to display
/// e.g. default image or title
class DefaultMetadata {
  DefaultMetadata({required this.defaultImage, required this.defaultTitle});

  final String defaultImage;
  final String defaultTitle;
}

abstract class PlayerInterface {
  PlayerInterface();

  final isStopped = ValueNotifier(true);
  final currentSongTitle = ValueNotifier('');
  final currentImage = ValueNotifier('');
  final playbackSpeed = ValueNotifier<double>(1);

// final currentIndex = ValueNotifier('');
  final progressState = ValueNotifier(
    const ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  final isFirstSong = ValueNotifier(true);
  final isLastSong = ValueNotifier(true);
  final playButton = ValueNotifier(ButtonState.paused);

// final isShuffleModeEnabled = ValueNotifier(false);

  ///Use this to load your data in
  Future<void> loadMedia(
    List<MediaItem> input, {
    Duration listenedPos = Duration.zero,
    int trackIndex = 0,
  });

  Future<void> play();

  Future<void> pause();

  Future<void> next();

  Future<void> previous();

  Future<void> setSpeed();

  Future<void> seek(Duration position);

  Future<void> skipToTrack({
    Duration position = Duration.zero,
    int trackIndex = 0,
  });

  Future<void> seekForward(Duration positionOffset);

  Future<void> seekBackward(Duration positionOffset);

  Future<void> stop();
}