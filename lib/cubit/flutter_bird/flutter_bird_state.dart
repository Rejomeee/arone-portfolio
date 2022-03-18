part of 'flutter_bird_cubit.dart';

@immutable
abstract class FlutterBirdState {}

class FlutterBirdInitial extends FlutterBirdState {}

class FlutterBirdMove extends FlutterBirdState {
  final Artboard? flutterBirdArtboard;

  FlutterBirdMove({
    this.flutterBirdArtboard,
  });
}
