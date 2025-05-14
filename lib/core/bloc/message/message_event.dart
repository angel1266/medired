part of 'message_bloc.dart';

sealed class MessageEvent extends Equatable implements Mappable {
  final String message;
  final Color? color;
  final MapEntry<String, void Function()>? action;
  const MessageEvent(this.message, {this.color, this.action});

  @override
  List<Object?> get props => [message, color, action];

  @override
  Map<String, dynamic> toMap() => {
        'message': message,
        'color': color,
        'action': action?.key,
      };
}

final class DisplayMessage extends MessageEvent {
  const DisplayMessage(super.message, {super.color, super.action});
}
