import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'webview_event.dart';
part 'webview_state.dart';

class WebviewBloc extends Bloc<WebviewEvent, WebviewState> {
  WebviewBloc() : super(WebviewSummaryLoading()) {
    on<SummaryRequested>((event, emit) {
      emit(WebviewSummaryLoading());
      emit(WebviewSummaryLoaded());
    });
  }
}
