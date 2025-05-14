part of 'message_bloc.dart';

sealed class MessageState extends Equatable implements Mappable {
  final String message;
  final DateTime time;
  final Color? color;
  final MapEntry<String, void Function()>? action;
  const MessageState(this.message,
      {required this.time, this.color, this.action});

  @override
  List<Object?> get props => [message, time, color];

  @override
  Map<String, dynamic> toMap() => {
        'message': message,
        'color': color?.value,
      };
}

final class DisplayedMessageState extends MessageState {
  const DisplayedMessageState(super.message,
      {required super.time, super.color, super.action});
}
