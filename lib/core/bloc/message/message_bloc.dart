import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_devtools/flutter_bloc_devtools.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(DisplayedMessageState('', time: DateTime.now())) {
    on<DisplayMessage>(_displayMessage);
  }

  Future<void> _displayMessage(
      DisplayMessage event, Emitter<MessageState> emit) async {
    emit(DisplayedMessageState(event.message,
        time: DateTime.now(), color: event.color, action: event.action));
  }
}
