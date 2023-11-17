import 'package:smart_capture_mobile/enum/album_customer_type_enum.dart';
import 'package:smart_capture_mobile/enum/create_album_error.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class CreateAlbumEvent {
  const CreateAlbumEvent();
}

@immutable
class SingleSelectEvent extends CreateAlbumEvent {
  final CustomerType customerType;

  const SingleSelectEvent(this.customerType);
}

@immutable
class OnTextChangedEvent extends CreateAlbumEvent {
  final String customerIdentity;
  final String customerName;

  const OnTextChangedEvent(
    this.customerIdentity,
    this.customerName,
  );
}

@immutable
class CheckLimitEvent extends CreateAlbumEvent {
  final int limitAlbumParam;

  const CheckLimitEvent(
    this.limitAlbumParam,
  );
}

@immutable
class CheckCustomerIdentityEvent extends CreateAlbumEvent {
  final String customerIdentity;
  final String customerName;
  final CreateAlbumError? error;

  const CheckCustomerIdentityEvent(
    this.customerIdentity,
    this.customerName,
    this.error,
  );
}

@immutable
class SaveAlbumEvent extends CreateAlbumEvent {
  final String customerType;
  final String customerIdentity;
  final String customerName;
  final String? customerCode;
  final CreateAlbumError? error;

  const SaveAlbumEvent(
    this.customerType,
    this.customerIdentity,
    this.customerName,
    this.customerCode,
    this.error,
  );
}
