part of isar;

/// Extension for QueryBuilders.
extension QueryWhereOr<OBJ, R> on QueryBuilder<OBJ, R, QWhereOr> {
  /// Union of two where clauses.
  QueryBuilder<OBJ, R, QWhereClause> or() {
    return copyWithInternal();
  }
}

/// @nodoc
@protected
typedef WhereRepeatModifier<OBJ, R, E> = QueryBuilder<OBJ, R, QAfterWhereClause>
    Function(QueryBuilder<OBJ, R, QWhereClause> q, E element);

/// Extension for QueryBuilders.
extension QueryWhere<OBJ, R> on QueryBuilder<OBJ, R, QWhereClause> {
  QueryBuilder<OBJ, R, QAfterWhereClause> anyOf<E, RS>(
      Iterable<E> items, WhereRepeatModifier<OBJ, R, E> modifier) {
    QueryBuilder<OBJ, R, QAfterWhereClause>? q;
    for (final e in items) {
      q = modifier(q?.or() ?? castInternal(), e);
    }
    return q ?? castInternal();
  }
}

/// Extension for QueryBuilders.
extension QueryFilter<OBJ, R> on QueryBuilder<OBJ, R, QFilter> {
  /// Start using filter conditions.
  QueryBuilder<OBJ, R, QFilterCondition> filter() {
    return copyWithInternal();
  }
}

/// @nodoc
@protected
typedef FilterRepeatModifier<OBJ, R, E>
    = QueryBuilder<OBJ, R, QAfterFilterCondition> Function(
        QueryBuilder<OBJ, R, QFilterCondition> q, E element);

/// Extension for QueryBuilders.
extension QueryFilterAndOr<OBJ, R> on QueryBuilder<OBJ, R, QFilterOperator> {
  /// Intersection of two filter conditions.
  QueryBuilder<OBJ, R, QFilterCondition> and() {
    return andOrInternal(FilterGroupType.and);
  }

  /// Union of two filter conditions.
  QueryBuilder<OBJ, R, QFilterCondition> or() {
    return andOrInternal(FilterGroupType.or);
  }
}

/// Extension for QueryBuilders.
extension QueryFilterNot<OBJ, R> on QueryBuilder<OBJ, R, QFilterCondition> {
  /// Complement the next filter condition or group.
  QueryBuilder<OBJ, R, QFilterCondition> not() {
    return notInternal();
  }

  QueryBuilder<OBJ, R, QAfterFilterCondition> anyOf<E, RS>(
      Iterable<E> items, FilterRepeatModifier<OBJ, R, E> modifier) {
    QueryBuilder<OBJ, R, QAfterFilterCondition>? q;
    for (final e in items) {
      q = modifier(q?.or() ?? castInternal(), e);
    }
    return q ?? castInternal();
  }

  QueryBuilder<OBJ, R, QAfterFilterCondition> allOf<E, RS>(
      Iterable<E> items, FilterRepeatModifier<OBJ, R, E> modifier) {
    QueryBuilder<OBJ, R, QAfterFilterCondition>? q;
    for (final e in items) {
      q = modifier(q?.and() ?? castInternal(), e);
    }
    return q ?? castInternal();
  }
}

/// Extension for QueryBuilders.
extension QueryFilterNoGroups<OBJ, R>
    on QueryBuilder<OBJ, R, QFilterCondition> {
  /// Group filter conditions.
  QueryBuilder<OBJ, R, QAfterFilterCondition> group(FilterQuery<OBJ> q) {
    return groupInternal(q);
  }
}

/// Extension for QueryBuilders.
extension QueryOffset<OBJ, R> on QueryBuilder<OBJ, R, QOffset> {
  /// Offset the query results by a static number.
  QueryBuilder<OBJ, R, QAfterOffset> offset(int offset) {
    return copyWithInternal(offset: offset);
  }
}

/// Extension for QueryBuilders.
extension QueryLimit<OBJ, R> on QueryBuilder<OBJ, R, QLimit> {
  /// Limit the maximum number of query results.
  QueryBuilder<OBJ, R, QAfterLimit> limit(int limit) {
    return copyWithInternal(limit: limit);
  }
}

/// @nodoc
@protected
typedef QueryOption<OBJ, S, RS> = QueryBuilder<OBJ, OBJ, RS> Function(
    QueryBuilder<OBJ, OBJ, S> q);

/// Extension for QueryBuilders.
extension QueryModifier<OBJ, S> on QueryBuilder<OBJ, OBJ, S> {
  /// Only apply a part of the query if `enabled` is true.
  QueryBuilder<OBJ, OBJ, RS> optional<RS>(
      bool enabled, QueryOption<OBJ, S, RS> option) {
    if (enabled) {
      return option(this);
    } else {
      return castInternal();
    }
  }
}

/// Extension for QueryBuilders
extension QueryExecute<OBJ, R> on QueryBuilder<OBJ, R, QQueryOperations> {
  /// Create a query from this query builder.
  Query<R> build() => buildInternal();

  /// {@macro query_find_first}
  Future<R?> findFirst() => build().findFirst();

  /// {@macro query_find_first}
  R? findFirstSync() => build().findFirstSync();

  /// {@macro query_find_all}
  Future<List<R>> findAll() => build().findAll();

  /// {@macro query_find_all}
  List<R> findAllSync() => build().findAllSync();

  /// {@macro query_count}
  Future<int> count() => build().count();

  /// {@macro query_count}
  int countSync() => build().countSync();

  /// {@macro query_delete_first}
  Future<bool> deleteFirst() => build().deleteFirst();

  /// {@macro query_delete_first}
  bool deleteFirstSync() => build().deleteFirstSync();

  /// {@macro query_delete_all}
  Future<int> deleteAll() => build().deleteAll();

  /// {@macro query_delete_all}
  int deleteAllSync() => build().deleteAllSync();

  /// {@macro query_watch}
  Stream<List<R>> watch({bool initialReturn = false}) =>
      build().watch(initialReturn: initialReturn);

  /// {@macro query_watch_lazy}
  Stream<void> watchLazy() => build().watchLazy();

  /// {@macro query_export_json_raw}
  Future<T> exportJsonRaw<T>(T Function(Uint8List) callback) =>
      build().exportJsonRaw(callback);

  /// {@macro query_export_json}
  Future<List<Map<String, dynamic>>> exportJson() => build().exportJson();
}

/// Extension for QueryBuilders
extension QueryExecuteAggregation<OBJ, T extends num>
    on QueryBuilder<OBJ, T?, QQueryOperations> {
  /// {@macro aggregation_min}
  Future<T?> min() => build().min();

  /// {@macro aggregation_min}
  T? minSync() => build().minSync();

  /// {@macro aggregation_max}
  Future<T?> max() => build().max();

  /// {@macro aggregation_max}
  T? maxSync() => build().maxSync();

  /// {@macro aggregation_average}
  Future<double> average() => build().average();

  /// {@macro aggregation_average}
  double averageSync() => build().averageSync();

  /// {@macro aggregation_sum}
  Future<T> sum() => build().sum();

  /// {@macro aggregation_sum}
  T sumSync() => build().sumSync();
}

/// Extension for QueryBuilders
extension QueryExecuteDateAggregation<OBJ>
    on QueryBuilder<OBJ, DateTime?, QQueryOperations> {
  /// {@macro aggregation_min}
  Future<DateTime?> min() => build().min();

  /// {@macro aggregation_min}
  DateTime? minSync() => build().minSync();

  /// {@macro aggregation_max}
  Future<DateTime?> max() => build().max();

  /// {@macro aggregation_max}
  DateTime? maxSync() => build().maxSync();
}
