import 'package:equatable/equatable.dart';

abstract class CustomEquatable extends Equatable {

  @override
  bool get stringify => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is CustomEquatable &&
              runtimeType == other.runtimeType &&
              props == other.props);
}