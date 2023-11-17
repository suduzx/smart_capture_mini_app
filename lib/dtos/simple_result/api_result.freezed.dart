part of 'api_result.dart';

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

mixin _$Result<Success, Failure> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Success success) success,
    required TResult Function(Failure failure) failure,
  }) =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Success success)? success,
    TResult? Function(Failure failure)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Success success)? success,
    TResult Function(Failure failure)? failure,
    required TResult Function() orElse,
  }) =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Success, Failure> value) success,
    required TResult Function(_Failure<Success, Failure> value) failure,
  }) =>
      throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Success, Failure> value)? success,
    TResult? Function(_Failure<Success, Failure> value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Success, Failure> value)? success,
    TResult Function(_Failure<Success, Failure> value)? failure,
    required TResult Function() orElse,
  }) =>
      throw _privateConstructorUsedError;
}

class _$_Success<Success, Failure> extends _Success<Success, Failure> {
  const _$_Success(this.success) : super._();

  @override
  final Success success;

  // @override
  // bool operator ==(dynamic other) {
  //   return identical(this, other) ||
  //       (other.runtimeType == runtimeType &&
  //           other is _$_Success<Success, Failure> &&
  //           const DeepCollectionEquality().equals(other.success, success));
  // }
  //
  // @override
  // int get hashCode =>
  //     Object.hash(runtimeType, const DeepCollectionEquality().hash(success));

  // @JsonKey(ignore: true)
  // @override
  // @pragma('vm:prefer-inline')
  // _$$_SuccessCopyWith<Success, Failure, _$_Success<Success, Failure>>
  //     get copyWith => __$$_SuccessCopyWithImpl<Success, Failure,
  //         _$_Success<Success, Failure>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Success success) success,
    required TResult Function(Failure failure) failure,
  }) {
    return success(this.success);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Success success)? success,
    TResult? Function(Failure failure)? failure,
  }) {
    return success?.call(this.success);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Success success)? success,
    TResult Function(Failure failure)? failure,
    required TResult Function() orElse,
  }) {
    if (success != null) {
      return success(this.success);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Success, Failure> value) success,
    required TResult Function(_Failure<Success, Failure> value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Success, Failure> value)? success,
    TResult? Function(_Failure<Success, Failure> value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Success, Failure> value)? success,
    TResult Function(_Failure<Success, Failure> value)? failure,
    required TResult Function() orElse,
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _Success<Success, Failure> extends Result<Success, Failure> {
  const factory _Success(final Success success) = _$_Success<Success, Failure>;

  const _Success._() : super._();

  @override
  Success get success;

// @JsonKey(ignore: true)
// _$$_SuccessCopyWith<Success, Failure, _$_Success<Success, Failure>>
//     get copyWith => throw _privateConstructorUsedError;
}

class _$_Failure<Success, Failure> extends _Failure<Success, Failure> {
  const _$_Failure(this.failure) : super._();

  @override
  final Failure failure;

  // @override
  // bool operator ==(dynamic other) {
  //   return identical(this, other) ||
  //       (other.runtimeType == runtimeType &&
  //           other is _$_Failure<Success, Failure> &&
  //           const DeepCollectionEquality().equals(other.failure, failure));
  // }
  //
  // @override
  // int get hashCode =>
  //     Object.hash(runtimeType, const DeepCollectionEquality().hash(failure));
  //
  // @JsonKey(ignore: true)
  // @override
  // @pragma('vm:prefer-inline')
  // _$$_FailureCopyWith<Success, Failure, _$_Failure<Success, Failure>>
  //     get copyWith => __$$_FailureCopyWithImpl<Success, Failure,
  //         _$_Failure<Success, Failure>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Success success) success,
    required TResult Function(Failure failure) failure,
  }) {
    return failure(this.failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Success success)? success,
    TResult? Function(Failure failure)? failure,
  }) {
    return failure?.call(this.failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Success success)? success,
    TResult Function(Failure failure)? failure,
    required TResult Function() orElse,
  }) {
    if (failure != null) {
      return failure(this.failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Success, Failure> value) success,
    required TResult Function(_Failure<Success, Failure> value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Success, Failure> value)? success,
    TResult? Function(_Failure<Success, Failure> value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Success, Failure> value)? success,
    TResult Function(_Failure<Success, Failure> value)? failure,
    required TResult Function() orElse,
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _Failure<Success, Failure> extends Result<Success, Failure> {
  const factory _Failure(final Failure failure) = _$_Failure<Success, Failure>;

  const _Failure._() : super._();

  @override
  Failure get failure;

// @JsonKey(ignore: true)
// _$$_FailureCopyWith<Success, Failure, _$_Failure<Success, Failure>>
//     get copyWith => throw _privateConstructorUsedError;
}
