import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rive/rive.dart';

part 'flutter_bird_state.dart';

class FlutterBirdCubit extends Cubit<FlutterBirdState> {
  FlutterBirdCubit() : super(FlutterBirdInitial());
  void animateFlutterBird(artboard1) => emit(FlutterBirdMove(
        flutterBirdArtboard: artboard1,
      ));
}
