// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BankCard _$BankCardFromJson(Map<String, dynamic> json) {
  return _BankCard.fromJson(json);
}

/// @nodoc
mixin _$BankCard {
  @HiveField(0)
  int get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get number => throw _privateConstructorUsedError;
  @HiveField(3)
  double get balance => throw _privateConstructorUsedError;

  /// Serializes this BankCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BankCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankCardCopyWith<BankCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankCardCopyWith<$Res> {
  factory $BankCardCopyWith(BankCard value, $Res Function(BankCard) then) =
      _$BankCardCopyWithImpl<$Res, BankCard>;
  @useResult
  $Res call(
      {@HiveField(0) int id,
      @HiveField(1) String name,
      @HiveField(2) String number,
      @HiveField(3) double balance});
}

/// @nodoc
class _$BankCardCopyWithImpl<$Res, $Val extends BankCard>
    implements $BankCardCopyWith<$Res> {
  _$BankCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BankCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? number = null,
    Object? balance = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankCardImplCopyWith<$Res>
    implements $BankCardCopyWith<$Res> {
  factory _$$BankCardImplCopyWith(
          _$BankCardImpl value, $Res Function(_$BankCardImpl) then) =
      __$$BankCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int id,
      @HiveField(1) String name,
      @HiveField(2) String number,
      @HiveField(3) double balance});
}

/// @nodoc
class __$$BankCardImplCopyWithImpl<$Res>
    extends _$BankCardCopyWithImpl<$Res, _$BankCardImpl>
    implements _$$BankCardImplCopyWith<$Res> {
  __$$BankCardImplCopyWithImpl(
      _$BankCardImpl _value, $Res Function(_$BankCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of BankCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? number = null,
    Object? balance = null,
  }) {
    return _then(_$BankCardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BankCardImpl implements _BankCard {
  const _$BankCardImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.number,
      @HiveField(3) required this.balance});

  factory _$BankCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankCardImplFromJson(json);

  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String number;
  @override
  @HiveField(3)
  final double balance;

  @override
  String toString() {
    return 'BankCard(id: $id, name: $name, number: $number, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, number, balance);

  /// Create a copy of BankCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankCardImplCopyWith<_$BankCardImpl> get copyWith =>
      __$$BankCardImplCopyWithImpl<_$BankCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankCardImplToJson(
      this,
    );
  }
}

abstract class _BankCard implements BankCard {
  const factory _BankCard(
      {@HiveField(0) required final int id,
      @HiveField(1) required final String name,
      @HiveField(2) required final String number,
      @HiveField(3) required final double balance}) = _$BankCardImpl;

  factory _BankCard.fromJson(Map<String, dynamic> json) =
      _$BankCardImpl.fromJson;

  @override
  @HiveField(0)
  int get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get number;
  @override
  @HiveField(3)
  double get balance;

  /// Create a copy of BankCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankCardImplCopyWith<_$BankCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
