// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostCommentModel _$PostCommentModelFromJson(Map<String, dynamic> json) {
  return _PostCommentModel.fromJson(json);
}

/// @nodoc
mixin _$PostCommentModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'post_id')
  String get postId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent_comment_id')
  String? get parentCommentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'comment_text')
  String get commentText => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_approved')
  bool get isApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_visible')
  bool get isVisible => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Nested relationships (when fetched with joins)
  ProfileModel? get profile =>
      throw _privateConstructorUsedError; // Commenter profile
  List<PostCommentModel>? get replies => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostCommentModelCopyWith<PostCommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCommentModelCopyWith<$Res> {
  factory $PostCommentModelCopyWith(
          PostCommentModel value, $Res Function(PostCommentModel) then) =
      _$PostCommentModelCopyWithImpl<$Res, PostCommentModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'post_id') String postId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'parent_comment_id') String? parentCommentId,
      @JsonKey(name: 'comment_text') String commentText,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'is_visible') bool isVisible,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      ProfileModel? profile,
      List<PostCommentModel>? replies});

  $ProfileModelCopyWith<$Res>? get profile;
}

/// @nodoc
class _$PostCommentModelCopyWithImpl<$Res, $Val extends PostCommentModel>
    implements $PostCommentModelCopyWith<$Res> {
  _$PostCommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? userId = null,
    Object? parentCommentId = freezed,
    Object? commentText = null,
    Object? isApproved = null,
    Object? isVisible = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? profile = freezed,
    Object? replies = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      commentText: null == commentText
          ? _value.commentText
          : commentText // ignore: cast_nullable_to_non_nullable
              as String,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as ProfileModel?,
      replies: freezed == replies
          ? _value.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<PostCommentModel>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileModelCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $ProfileModelCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostCommentModelImplCopyWith<$Res>
    implements $PostCommentModelCopyWith<$Res> {
  factory _$$PostCommentModelImplCopyWith(_$PostCommentModelImpl value,
          $Res Function(_$PostCommentModelImpl) then) =
      __$$PostCommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'post_id') String postId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'parent_comment_id') String? parentCommentId,
      @JsonKey(name: 'comment_text') String commentText,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'is_visible') bool isVisible,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      ProfileModel? profile,
      List<PostCommentModel>? replies});

  @override
  $ProfileModelCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$PostCommentModelImplCopyWithImpl<$Res>
    extends _$PostCommentModelCopyWithImpl<$Res, _$PostCommentModelImpl>
    implements _$$PostCommentModelImplCopyWith<$Res> {
  __$$PostCommentModelImplCopyWithImpl(_$PostCommentModelImpl _value,
      $Res Function(_$PostCommentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? userId = null,
    Object? parentCommentId = freezed,
    Object? commentText = null,
    Object? isApproved = null,
    Object? isVisible = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? profile = freezed,
    Object? replies = freezed,
  }) {
    return _then(_$PostCommentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      commentText: null == commentText
          ? _value.commentText
          : commentText // ignore: cast_nullable_to_non_nullable
              as String,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as ProfileModel?,
      replies: freezed == replies
          ? _value._replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<PostCommentModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostCommentModelImpl extends _PostCommentModel {
  const _$PostCommentModelImpl(
      {required this.id,
      @JsonKey(name: 'post_id') required this.postId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'parent_comment_id') this.parentCommentId,
      @JsonKey(name: 'comment_text') required this.commentText,
      @JsonKey(name: 'is_approved') this.isApproved = false,
      @JsonKey(name: 'is_visible') this.isVisible = true,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      this.profile,
      final List<PostCommentModel>? replies})
      : _replies = replies,
        super._();

  factory _$PostCommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostCommentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'post_id')
  final String postId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'parent_comment_id')
  final String? parentCommentId;
  @override
  @JsonKey(name: 'comment_text')
  final String commentText;
  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  @override
  @JsonKey(name: 'is_visible')
  final bool isVisible;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
// Nested relationships (when fetched with joins)
  @override
  final ProfileModel? profile;
// Commenter profile
  final List<PostCommentModel>? _replies;
// Commenter profile
  @override
  List<PostCommentModel>? get replies {
    final value = _replies;
    if (value == null) return null;
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PostCommentModel(id: $id, postId: $postId, userId: $userId, parentCommentId: $parentCommentId, commentText: $commentText, isApproved: $isApproved, isVisible: $isVisible, createdAt: $createdAt, updatedAt: $updatedAt, profile: $profile, replies: $replies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostCommentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId) &&
            (identical(other.commentText, commentText) ||
                other.commentText == commentText) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            const DeepCollectionEquality().equals(other._replies, _replies));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      postId,
      userId,
      parentCommentId,
      commentText,
      isApproved,
      isVisible,
      createdAt,
      updatedAt,
      profile,
      const DeepCollectionEquality().hash(_replies));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostCommentModelImplCopyWith<_$PostCommentModelImpl> get copyWith =>
      __$$PostCommentModelImplCopyWithImpl<_$PostCommentModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostCommentModelImplToJson(
      this,
    );
  }
}

abstract class _PostCommentModel extends PostCommentModel {
  const factory _PostCommentModel(
      {required final String id,
      @JsonKey(name: 'post_id') required final String postId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'parent_comment_id') final String? parentCommentId,
      @JsonKey(name: 'comment_text') required final String commentText,
      @JsonKey(name: 'is_approved') final bool isApproved,
      @JsonKey(name: 'is_visible') final bool isVisible,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final ProfileModel? profile,
      final List<PostCommentModel>? replies}) = _$PostCommentModelImpl;
  const _PostCommentModel._() : super._();

  factory _PostCommentModel.fromJson(Map<String, dynamic> json) =
      _$PostCommentModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'post_id')
  String get postId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'parent_comment_id')
  String? get parentCommentId;
  @override
  @JsonKey(name: 'comment_text')
  String get commentText;
  @override
  @JsonKey(name: 'is_approved')
  bool get isApproved;
  @override
  @JsonKey(name: 'is_visible')
  bool get isVisible;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override // Nested relationships (when fetched with joins)
  ProfileModel? get profile;
  @override // Commenter profile
  List<PostCommentModel>? get replies;
  @override
  @JsonKey(ignore: true)
  _$$PostCommentModelImplCopyWith<_$PostCommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
