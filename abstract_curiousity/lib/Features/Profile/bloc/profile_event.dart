// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@override
class ProfileDetailsRequested extends ProfileEvent {
  final String firebaseUid;
  final BuildContext context;

  ProfileDetailsRequested({required this.firebaseUid, required this.context});
}

@override
class ProfileDataUpdateRequested extends ProfileEvent {
  final String firebaseUid;
  final String name;
  final String bio;
  final BuildContext context;

  ProfileDataUpdateRequested({
    required this.firebaseUid,
    required this.name,
    required this.bio,
    required this.context,
  });
}
