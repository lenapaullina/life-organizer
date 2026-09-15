// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $HouseholdTasksTable extends HouseholdTasks
    with TableInfo<$HouseholdTasksTable, HouseholdTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastCompletedAtMeta =
      const VerificationMeta('lastCompletedAt');
  @override
  late final GeneratedColumn<DateTime> lastCompletedAt =
      GeneratedColumn<DateTime>('last_completed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
      'notifications_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notifications_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        icon,
        intervalDays,
        lastCompletedAt,
        category,
        notificationsEnabled,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'household_tasks';
  @override
  VerificationContext validateIntegrity(Insertable<HouseholdTask> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    } else if (isInserting) {
      context.missing(_intervalDaysMeta);
    }
    if (data.containsKey('last_completed_at')) {
      context.handle(
          _lastCompletedAtMeta,
          lastCompletedAt.isAcceptableOrUnknown(
              data['last_completed_at']!, _lastCompletedAtMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
          _notificationsEnabledMeta,
          notificationsEnabled.isAcceptableOrUnknown(
              data['notifications_enabled']!, _notificationsEnabledMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdTask(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days'])!,
      lastCompletedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_completed_at']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      notificationsEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}notifications_enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $HouseholdTasksTable createAlias(String alias) {
    return $HouseholdTasksTable(attachedDatabase, alias);
  }
}

class HouseholdTask extends DataClass implements Insertable<HouseholdTask> {
  final String id;
  final String name;
  final String? icon;
  final int intervalDays;
  final DateTime? lastCompletedAt;
  final String? category;
  final bool notificationsEnabled;
  final DateTime createdAt;
  const HouseholdTask(
      {required this.id,
      required this.name,
      this.icon,
      required this.intervalDays,
      this.lastCompletedAt,
      this.category,
      required this.notificationsEnabled,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['interval_days'] = Variable<int>(intervalDays);
    if (!nullToAbsent || lastCompletedAt != null) {
      map['last_completed_at'] = Variable<DateTime>(lastCompletedAt);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HouseholdTasksCompanion toCompanion(bool nullToAbsent) {
    return HouseholdTasksCompanion(
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      intervalDays: Value(intervalDays),
      lastCompletedAt: lastCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedAt),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      notificationsEnabled: Value(notificationsEnabled),
      createdAt: Value(createdAt),
    );
  }

  factory HouseholdTask.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdTask(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      lastCompletedAt: serializer.fromJson<DateTime?>(json['lastCompletedAt']),
      category: serializer.fromJson<String?>(json['category']),
      notificationsEnabled:
          serializer.fromJson<bool>(json['notificationsEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'lastCompletedAt': serializer.toJson<DateTime?>(lastCompletedAt),
      'category': serializer.toJson<String?>(category),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HouseholdTask copyWith(
          {String? id,
          String? name,
          Value<String?> icon = const Value.absent(),
          int? intervalDays,
          Value<DateTime?> lastCompletedAt = const Value.absent(),
          Value<String?> category = const Value.absent(),
          bool? notificationsEnabled,
          DateTime? createdAt}) =>
      HouseholdTask(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon.present ? icon.value : this.icon,
        intervalDays: intervalDays ?? this.intervalDays,
        lastCompletedAt: lastCompletedAt.present
            ? lastCompletedAt.value
            : this.lastCompletedAt,
        category: category.present ? category.value : this.category,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        createdAt: createdAt ?? this.createdAt,
      );
  HouseholdTask copyWithCompanion(HouseholdTasksCompanion data) {
    return HouseholdTask(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      lastCompletedAt: data.lastCompletedAt.present
          ? data.lastCompletedAt.value
          : this.lastCompletedAt,
      category: data.category.present ? data.category.value : this.category,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdTask(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastCompletedAt: $lastCompletedAt, ')
          ..write('category: $category, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, intervalDays, lastCompletedAt,
      category, notificationsEnabled, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdTask &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.intervalDays == this.intervalDays &&
          other.lastCompletedAt == this.lastCompletedAt &&
          other.category == this.category &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.createdAt == this.createdAt);
}

class HouseholdTasksCompanion extends UpdateCompanion<HouseholdTask> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<int> intervalDays;
  final Value<DateTime?> lastCompletedAt;
  final Value<String?> category;
  final Value<bool> notificationsEnabled;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HouseholdTasksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.lastCompletedAt = const Value.absent(),
    this.category = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HouseholdTasksCompanion.insert({
    required String id,
    required String name,
    this.icon = const Value.absent(),
    required int intervalDays,
    this.lastCompletedAt = const Value.absent(),
    this.category = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        intervalDays = Value(intervalDays);
  static Insertable<HouseholdTask> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? intervalDays,
    Expression<DateTime>? lastCompletedAt,
    Expression<String>? category,
    Expression<bool>? notificationsEnabled,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (lastCompletedAt != null) 'last_completed_at': lastCompletedAt,
      if (category != null) 'category': category,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HouseholdTasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? icon,
      Value<int>? intervalDays,
      Value<DateTime?>? lastCompletedAt,
      Value<String?>? category,
      Value<bool>? notificationsEnabled,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return HouseholdTasksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      intervalDays: intervalDays ?? this.intervalDays,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      category: category ?? this.category,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (lastCompletedAt.present) {
      map['last_completed_at'] = Variable<DateTime>(lastCompletedAt.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdTasksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastCompletedAt: $lastCompletedAt, ')
          ..write('category: $category, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskCompletionLogsTable extends TaskCompletionLogs
    with TableInfo<$TaskCompletionLogsTable, TaskCompletionLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCompletionLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES household_tasks (id) ON DELETE CASCADE'));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, taskId, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_completion_logs';
  @override
  VerificationContext validateIntegrity(Insertable<TaskCompletionLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskCompletionLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCompletionLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
    );
  }

  @override
  $TaskCompletionLogsTable createAlias(String alias) {
    return $TaskCompletionLogsTable(attachedDatabase, alias);
  }
}

class TaskCompletionLog extends DataClass
    implements Insertable<TaskCompletionLog> {
  final String id;
  final String taskId;
  final DateTime completedAt;
  const TaskCompletionLog(
      {required this.id, required this.taskId, required this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  TaskCompletionLogsCompanion toCompanion(bool nullToAbsent) {
    return TaskCompletionLogsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      completedAt: Value(completedAt),
    );
  }

  factory TaskCompletionLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCompletionLog(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  TaskCompletionLog copyWith(
          {String? id, String? taskId, DateTime? completedAt}) =>
      TaskCompletionLog(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        completedAt: completedAt ?? this.completedAt,
      );
  TaskCompletionLog copyWithCompanion(TaskCompletionLogsCompanion data) {
    return TaskCompletionLog(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCompletionLog(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCompletionLog &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.completedAt == this.completedAt);
}

class TaskCompletionLogsCompanion extends UpdateCompanion<TaskCompletionLog> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const TaskCompletionLogsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskCompletionLogsCompanion.insert({
    required String id,
    required String taskId,
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskId = Value(taskId),
        completedAt = Value(completedAt);
  static Insertable<TaskCompletionLog> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskCompletionLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<DateTime>? completedAt,
      Value<int>? rowid}) {
    return TaskCompletionLogsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCompletionLogsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _streakEnabledMeta =
      const VerificationMeta('streakEnabled');
  @override
  late final GeneratedColumn<bool> streakEnabled = GeneratedColumn<bool>(
      'streak_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("streak_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, name, type, streakEnabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(Insertable<Routine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('streak_enabled')) {
      context.handle(
          _streakEnabledMeta,
          streakEnabled.isAcceptableOrUnknown(
              data['streak_enabled']!, _streakEnabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      streakEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}streak_enabled'])!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class Routine extends DataClass implements Insertable<Routine> {
  final String id;
  final String name;
  final String type;
  final bool streakEnabled;
  const Routine(
      {required this.id,
      required this.name,
      required this.type,
      required this.streakEnabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['streak_enabled'] = Variable<bool>(streakEnabled);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      streakEnabled: Value(streakEnabled),
    );
  }

  factory Routine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      streakEnabled: serializer.fromJson<bool>(json['streakEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'streakEnabled': serializer.toJson<bool>(streakEnabled),
    };
  }

  Routine copyWith(
          {String? id, String? name, String? type, bool? streakEnabled}) =>
      Routine(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        streakEnabled: streakEnabled ?? this.streakEnabled,
      );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      streakEnabled: data.streakEnabled.present
          ? data.streakEnabled.value
          : this.streakEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('streakEnabled: $streakEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, streakEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.streakEnabled == this.streakEnabled);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<bool> streakEnabled;
  final Value<int> rowid;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.streakEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutinesCompanion.insert({
    required String id,
    required String name,
    required String type,
    this.streakEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type);
  static Insertable<Routine> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<bool>? streakEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (streakEnabled != null) 'streak_enabled': streakEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutinesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<bool>? streakEnabled,
      Value<int>? rowid}) {
    return RoutinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      streakEnabled: streakEnabled ?? this.streakEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (streakEnabled.present) {
      map['streak_enabled'] = Variable<bool>(streakEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('streakEnabled: $streakEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineItemsTable extends RoutineItems
    with TableInfo<$RoutineItemsTable, RoutineItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _routineIdMeta =
      const VerificationMeta('routineId');
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
      'routine_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES routines (id) ON DELETE CASCADE'));
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'item_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, routineId, label, sortOrder, icon];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_items';
  @override
  VerificationContext validateIntegrity(Insertable<RoutineItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(_routineIdMeta,
          routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta));
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('item_text')) {
      context.handle(_labelMeta,
          label.isAcceptableOrUnknown(data['item_text']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      routineId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}routine_id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_text'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
    );
  }

  @override
  $RoutineItemsTable createAlias(String alias) {
    return $RoutineItemsTable(attachedDatabase, alias);
  }
}

class RoutineItem extends DataClass implements Insertable<RoutineItem> {
  final String id;
  final String routineId;
  final String label;
  final int sortOrder;
  final String? icon;
  const RoutineItem(
      {required this.id,
      required this.routineId,
      required this.label,
      required this.sortOrder,
      this.icon});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['routine_id'] = Variable<String>(routineId);
    map['item_text'] = Variable<String>(label);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    return map;
  }

  RoutineItemsCompanion toCompanion(bool nullToAbsent) {
    return RoutineItemsCompanion(
      id: Value(id),
      routineId: Value(routineId),
      label: Value(label),
      sortOrder: Value(sortOrder),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
    );
  }

  factory RoutineItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineItem(
      id: serializer.fromJson<String>(json['id']),
      routineId: serializer.fromJson<String>(json['routineId']),
      label: serializer.fromJson<String>(json['label']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      icon: serializer.fromJson<String?>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineId': serializer.toJson<String>(routineId),
      'label': serializer.toJson<String>(label),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'icon': serializer.toJson<String?>(icon),
    };
  }

  RoutineItem copyWith(
          {String? id,
          String? routineId,
          String? label,
          int? sortOrder,
          Value<String?> icon = const Value.absent()}) =>
      RoutineItem(
        id: id ?? this.id,
        routineId: routineId ?? this.routineId,
        label: label ?? this.label,
        sortOrder: sortOrder ?? this.sortOrder,
        icon: icon.present ? icon.value : this.icon,
      );
  RoutineItem copyWithCompanion(RoutineItemsCompanion data) {
    return RoutineItem(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      label: data.label.present ? data.label.value : this.label,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      icon: data.icon.present ? data.icon.value : this.icon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineItem(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('label: $label, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, routineId, label, sortOrder, icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineItem &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.label == this.label &&
          other.sortOrder == this.sortOrder &&
          other.icon == this.icon);
}

class RoutineItemsCompanion extends UpdateCompanion<RoutineItem> {
  final Value<String> id;
  final Value<String> routineId;
  final Value<String> label;
  final Value<int> sortOrder;
  final Value<String?> icon;
  final Value<int> rowid;
  const RoutineItemsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.label = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineItemsCompanion.insert({
    required String id,
    required String routineId,
    required String label,
    required int sortOrder,
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        routineId = Value(routineId),
        label = Value(label),
        sortOrder = Value(sortOrder);
  static Insertable<RoutineItem> custom({
    Expression<String>? id,
    Expression<String>? routineId,
    Expression<String>? label,
    Expression<int>? sortOrder,
    Expression<String>? icon,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (label != null) 'item_text': label,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (icon != null) 'icon': icon,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? routineId,
      Value<String>? label,
      Value<int>? sortOrder,
      Value<String?>? icon,
      Value<int>? rowid}) {
    return RoutineItemsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      label: label ?? this.label,
      sortOrder: sortOrder ?? this.sortOrder,
      icon: icon ?? this.icon,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (label.present) {
      map['item_text'] = Variable<String>(label.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineItemsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('label: $label, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('icon: $icon, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineCompletionsTable extends RoutineCompletions
    with TableInfo<$RoutineCompletionsTable, RoutineCompletion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _routineIdMeta =
      const VerificationMeta('routineId');
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
      'routine_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES routines (id) ON DELETE CASCADE'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedItemIdsMeta =
      const VerificationMeta('completedItemIds');
  @override
  late final GeneratedColumn<String> completedItemIds = GeneratedColumn<String>(
      'completed_item_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullyCompletedMeta =
      const VerificationMeta('fullyCompleted');
  @override
  late final GeneratedColumn<bool> fullyCompleted = GeneratedColumn<bool>(
      'fully_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("fully_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, routineId, date, completedItemIds, fullyCompleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_completions';
  @override
  VerificationContext validateIntegrity(Insertable<RoutineCompletion> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(_routineIdMeta,
          routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta));
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('completed_item_ids')) {
      context.handle(
          _completedItemIdsMeta,
          completedItemIds.isAcceptableOrUnknown(
              data['completed_item_ids']!, _completedItemIdsMeta));
    } else if (isInserting) {
      context.missing(_completedItemIdsMeta);
    }
    if (data.containsKey('fully_completed')) {
      context.handle(
          _fullyCompletedMeta,
          fullyCompleted.isAcceptableOrUnknown(
              data['fully_completed']!, _fullyCompletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineCompletion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineCompletion(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      routineId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}routine_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      completedItemIds: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}completed_item_ids'])!,
      fullyCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}fully_completed'])!,
    );
  }

  @override
  $RoutineCompletionsTable createAlias(String alias) {
    return $RoutineCompletionsTable(attachedDatabase, alias);
  }
}

class RoutineCompletion extends DataClass
    implements Insertable<RoutineCompletion> {
  final String id;
  final String routineId;
  final DateTime date;
  final String completedItemIds;
  final bool fullyCompleted;
  const RoutineCompletion(
      {required this.id,
      required this.routineId,
      required this.date,
      required this.completedItemIds,
      required this.fullyCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['routine_id'] = Variable<String>(routineId);
    map['date'] = Variable<DateTime>(date);
    map['completed_item_ids'] = Variable<String>(completedItemIds);
    map['fully_completed'] = Variable<bool>(fullyCompleted);
    return map;
  }

  RoutineCompletionsCompanion toCompanion(bool nullToAbsent) {
    return RoutineCompletionsCompanion(
      id: Value(id),
      routineId: Value(routineId),
      date: Value(date),
      completedItemIds: Value(completedItemIds),
      fullyCompleted: Value(fullyCompleted),
    );
  }

  factory RoutineCompletion.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineCompletion(
      id: serializer.fromJson<String>(json['id']),
      routineId: serializer.fromJson<String>(json['routineId']),
      date: serializer.fromJson<DateTime>(json['date']),
      completedItemIds: serializer.fromJson<String>(json['completedItemIds']),
      fullyCompleted: serializer.fromJson<bool>(json['fullyCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineId': serializer.toJson<String>(routineId),
      'date': serializer.toJson<DateTime>(date),
      'completedItemIds': serializer.toJson<String>(completedItemIds),
      'fullyCompleted': serializer.toJson<bool>(fullyCompleted),
    };
  }

  RoutineCompletion copyWith(
          {String? id,
          String? routineId,
          DateTime? date,
          String? completedItemIds,
          bool? fullyCompleted}) =>
      RoutineCompletion(
        id: id ?? this.id,
        routineId: routineId ?? this.routineId,
        date: date ?? this.date,
        completedItemIds: completedItemIds ?? this.completedItemIds,
        fullyCompleted: fullyCompleted ?? this.fullyCompleted,
      );
  RoutineCompletion copyWithCompanion(RoutineCompletionsCompanion data) {
    return RoutineCompletion(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      date: data.date.present ? data.date.value : this.date,
      completedItemIds: data.completedItemIds.present
          ? data.completedItemIds.value
          : this.completedItemIds,
      fullyCompleted: data.fullyCompleted.present
          ? data.fullyCompleted.value
          : this.fullyCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineCompletion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('date: $date, ')
          ..write('completedItemIds: $completedItemIds, ')
          ..write('fullyCompleted: $fullyCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, routineId, date, completedItemIds, fullyCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineCompletion &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.date == this.date &&
          other.completedItemIds == this.completedItemIds &&
          other.fullyCompleted == this.fullyCompleted);
}

class RoutineCompletionsCompanion extends UpdateCompanion<RoutineCompletion> {
  final Value<String> id;
  final Value<String> routineId;
  final Value<DateTime> date;
  final Value<String> completedItemIds;
  final Value<bool> fullyCompleted;
  final Value<int> rowid;
  const RoutineCompletionsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.date = const Value.absent(),
    this.completedItemIds = const Value.absent(),
    this.fullyCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineCompletionsCompanion.insert({
    required String id,
    required String routineId,
    required DateTime date,
    required String completedItemIds,
    this.fullyCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        routineId = Value(routineId),
        date = Value(date),
        completedItemIds = Value(completedItemIds);
  static Insertable<RoutineCompletion> custom({
    Expression<String>? id,
    Expression<String>? routineId,
    Expression<DateTime>? date,
    Expression<String>? completedItemIds,
    Expression<bool>? fullyCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (date != null) 'date': date,
      if (completedItemIds != null) 'completed_item_ids': completedItemIds,
      if (fullyCompleted != null) 'fully_completed': fullyCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineCompletionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? routineId,
      Value<DateTime>? date,
      Value<String>? completedItemIds,
      Value<bool>? fullyCompleted,
      Value<int>? rowid}) {
    return RoutineCompletionsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      date: date ?? this.date,
      completedItemIds: completedItemIds ?? this.completedItemIds,
      fullyCompleted: fullyCompleted ?? this.fullyCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (completedItemIds.present) {
      map['completed_item_ids'] = Variable<String>(completedItemIds.value);
    }
    if (fullyCompleted.present) {
      map['fully_completed'] = Variable<bool>(fullyCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineCompletionsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('date: $date, ')
          ..write('completedItemIds: $completedItemIds, ')
          ..write('fullyCompleted: $fullyCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrainDumpEntriesTable extends BrainDumpEntries
    with TableInfo<$BrainDumpEntriesTable, BrainDumpEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrainDumpEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'entry_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
      'done', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("done" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool> pinned = GeneratedColumn<bool>(
      'pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, content, createdAt, done, category, priority, pinned];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brain_dump_entries';
  @override
  VerificationContext validateIntegrity(Insertable<BrainDumpEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entry_text')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['entry_text']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('done')) {
      context.handle(
          _doneMeta, done.isAcceptableOrUnknown(data['done']!, _doneMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('pinned')) {
      context.handle(_pinnedMeta,
          pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BrainDumpEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrainDumpEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entry_text'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      done: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}done'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      pinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pinned'])!,
    );
  }

  @override
  $BrainDumpEntriesTable createAlias(String alias) {
    return $BrainDumpEntriesTable(attachedDatabase, alias);
  }
}

class BrainDumpEntry extends DataClass implements Insertable<BrainDumpEntry> {
  final String id;
  final String content;
  final DateTime createdAt;
  final bool done;
  final String? category;

  /// 0 = niedrig, 1 = mittel, 2 = hoch
  final int priority;
  final bool pinned;
  const BrainDumpEntry(
      {required this.id,
      required this.content,
      required this.createdAt,
      required this.done,
      this.category,
      required this.priority,
      required this.pinned});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entry_text'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['done'] = Variable<bool>(done);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['priority'] = Variable<int>(priority);
    map['pinned'] = Variable<bool>(pinned);
    return map;
  }

  BrainDumpEntriesCompanion toCompanion(bool nullToAbsent) {
    return BrainDumpEntriesCompanion(
      id: Value(id),
      content: Value(content),
      createdAt: Value(createdAt),
      done: Value(done),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      priority: Value(priority),
      pinned: Value(pinned),
    );
  }

  factory BrainDumpEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrainDumpEntry(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      done: serializer.fromJson<bool>(json['done']),
      category: serializer.fromJson<String?>(json['category']),
      priority: serializer.fromJson<int>(json['priority']),
      pinned: serializer.fromJson<bool>(json['pinned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'done': serializer.toJson<bool>(done),
      'category': serializer.toJson<String?>(category),
      'priority': serializer.toJson<int>(priority),
      'pinned': serializer.toJson<bool>(pinned),
    };
  }

  BrainDumpEntry copyWith(
          {String? id,
          String? content,
          DateTime? createdAt,
          bool? done,
          Value<String?> category = const Value.absent(),
          int? priority,
          bool? pinned}) =>
      BrainDumpEntry(
        id: id ?? this.id,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        done: done ?? this.done,
        category: category.present ? category.value : this.category,
        priority: priority ?? this.priority,
        pinned: pinned ?? this.pinned,
      );
  BrainDumpEntry copyWithCompanion(BrainDumpEntriesCompanion data) {
    return BrainDumpEntry(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      done: data.done.present ? data.done.value : this.done,
      category: data.category.present ? data.category.value : this.category,
      priority: data.priority.present ? data.priority.value : this.priority,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrainDumpEntry(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('done: $done, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('pinned: $pinned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, content, createdAt, done, category, priority, pinned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrainDumpEntry &&
          other.id == this.id &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.done == this.done &&
          other.category == this.category &&
          other.priority == this.priority &&
          other.pinned == this.pinned);
}

class BrainDumpEntriesCompanion extends UpdateCompanion<BrainDumpEntry> {
  final Value<String> id;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<bool> done;
  final Value<String?> category;
  final Value<int> priority;
  final Value<bool> pinned;
  final Value<int> rowid;
  const BrainDumpEntriesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.done = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.pinned = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BrainDumpEntriesCompanion.insert({
    required String id,
    required String content,
    this.createdAt = const Value.absent(),
    this.done = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.pinned = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        content = Value(content);
  static Insertable<BrainDumpEntry> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<bool>? done,
    Expression<String>? category,
    Expression<int>? priority,
    Expression<bool>? pinned,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'entry_text': content,
      if (createdAt != null) 'created_at': createdAt,
      if (done != null) 'done': done,
      if (category != null) 'category': category,
      if (priority != null) 'priority': priority,
      if (pinned != null) 'pinned': pinned,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BrainDumpEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<bool>? done,
      Value<String?>? category,
      Value<int>? priority,
      Value<bool>? pinned,
      Value<int>? rowid}) {
    return BrainDumpEntriesCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      done: done ?? this.done,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      pinned: pinned ?? this.pinned,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['entry_text'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrainDumpEntriesCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('done: $done, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('pinned: $pinned, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PantryItemsTable extends PantryItems
    with TableInfo<$PantryItemsTable, PantryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PantryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _openedAtMeta =
      const VerificationMeta('openedAt');
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
      'opened_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _daysGoodAfterOpeningMeta =
      const VerificationMeta('daysGoodAfterOpening');
  @override
  late final GeneratedColumn<int> daysGoodAfterOpening = GeneratedColumn<int>(
      'days_good_after_opening', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        icon,
        category,
        expiryDate,
        openedAt,
        daysGoodAfterOpening,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pantry_items';
  @override
  VerificationContext validateIntegrity(Insertable<PantryItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    } else if (isInserting) {
      context.missing(_expiryDateMeta);
    }
    if (data.containsKey('opened_at')) {
      context.handle(_openedAtMeta,
          openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta));
    }
    if (data.containsKey('days_good_after_opening')) {
      context.handle(
          _daysGoodAfterOpeningMeta,
          daysGoodAfterOpening.isAcceptableOrUnknown(
              data['days_good_after_opening']!, _daysGoodAfterOpeningMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PantryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PantryItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date'])!,
      openedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}opened_at']),
      daysGoodAfterOpening: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}days_good_after_opening']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PantryItemsTable createAlias(String alias) {
    return $PantryItemsTable(attachedDatabase, alias);
  }
}

class PantryItem extends DataClass implements Insertable<PantryItem> {
  final String id;
  final String name;
  final String? icon;
  final String? category;
  final DateTime expiryDate;
  final DateTime? openedAt;
  final int? daysGoodAfterOpening;
  final DateTime createdAt;
  const PantryItem(
      {required this.id,
      required this.name,
      this.icon,
      this.category,
      required this.expiryDate,
      this.openedAt,
      this.daysGoodAfterOpening,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['expiry_date'] = Variable<DateTime>(expiryDate);
    if (!nullToAbsent || openedAt != null) {
      map['opened_at'] = Variable<DateTime>(openedAt);
    }
    if (!nullToAbsent || daysGoodAfterOpening != null) {
      map['days_good_after_opening'] = Variable<int>(daysGoodAfterOpening);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PantryItemsCompanion toCompanion(bool nullToAbsent) {
    return PantryItemsCompanion(
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      expiryDate: Value(expiryDate),
      openedAt: openedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(openedAt),
      daysGoodAfterOpening: daysGoodAfterOpening == null && nullToAbsent
          ? const Value.absent()
          : Value(daysGoodAfterOpening),
      createdAt: Value(createdAt),
    );
  }

  factory PantryItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PantryItem(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      category: serializer.fromJson<String?>(json['category']),
      expiryDate: serializer.fromJson<DateTime>(json['expiryDate']),
      openedAt: serializer.fromJson<DateTime?>(json['openedAt']),
      daysGoodAfterOpening:
          serializer.fromJson<int?>(json['daysGoodAfterOpening']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'category': serializer.toJson<String?>(category),
      'expiryDate': serializer.toJson<DateTime>(expiryDate),
      'openedAt': serializer.toJson<DateTime?>(openedAt),
      'daysGoodAfterOpening': serializer.toJson<int?>(daysGoodAfterOpening),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PantryItem copyWith(
          {String? id,
          String? name,
          Value<String?> icon = const Value.absent(),
          Value<String?> category = const Value.absent(),
          DateTime? expiryDate,
          Value<DateTime?> openedAt = const Value.absent(),
          Value<int?> daysGoodAfterOpening = const Value.absent(),
          DateTime? createdAt}) =>
      PantryItem(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon.present ? icon.value : this.icon,
        category: category.present ? category.value : this.category,
        expiryDate: expiryDate ?? this.expiryDate,
        openedAt: openedAt.present ? openedAt.value : this.openedAt,
        daysGoodAfterOpening: daysGoodAfterOpening.present
            ? daysGoodAfterOpening.value
            : this.daysGoodAfterOpening,
        createdAt: createdAt ?? this.createdAt,
      );
  PantryItem copyWithCompanion(PantryItemsCompanion data) {
    return PantryItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      category: data.category.present ? data.category.value : this.category,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      daysGoodAfterOpening: data.daysGoodAfterOpening.present
          ? data.daysGoodAfterOpening.value
          : this.daysGoodAfterOpening,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PantryItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('category: $category, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('openedAt: $openedAt, ')
          ..write('daysGoodAfterOpening: $daysGoodAfterOpening, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, category, expiryDate,
      openedAt, daysGoodAfterOpening, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PantryItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.category == this.category &&
          other.expiryDate == this.expiryDate &&
          other.openedAt == this.openedAt &&
          other.daysGoodAfterOpening == this.daysGoodAfterOpening &&
          other.createdAt == this.createdAt);
}

class PantryItemsCompanion extends UpdateCompanion<PantryItem> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<String?> category;
  final Value<DateTime> expiryDate;
  final Value<DateTime?> openedAt;
  final Value<int?> daysGoodAfterOpening;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PantryItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.category = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.daysGoodAfterOpening = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PantryItemsCompanion.insert({
    required String id,
    required String name,
    this.icon = const Value.absent(),
    this.category = const Value.absent(),
    required DateTime expiryDate,
    this.openedAt = const Value.absent(),
    this.daysGoodAfterOpening = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        expiryDate = Value(expiryDate);
  static Insertable<PantryItem> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? category,
    Expression<DateTime>? expiryDate,
    Expression<DateTime>? openedAt,
    Expression<int>? daysGoodAfterOpening,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (category != null) 'category': category,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (openedAt != null) 'opened_at': openedAt,
      if (daysGoodAfterOpening != null)
        'days_good_after_opening': daysGoodAfterOpening,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PantryItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? icon,
      Value<String?>? category,
      Value<DateTime>? expiryDate,
      Value<DateTime?>? openedAt,
      Value<int?>? daysGoodAfterOpening,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PantryItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      expiryDate: expiryDate ?? this.expiryDate,
      openedAt: openedAt ?? this.openedAt,
      daysGoodAfterOpening: daysGoodAfterOpening ?? this.daysGoodAfterOpening,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (daysGoodAfterOpening.present) {
      map['days_good_after_opening'] =
          Variable<int>(daysGoodAfterOpening.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PantryItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('category: $category, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('openedAt: $openedAt, ')
          ..write('daysGoodAfterOpening: $daysGoodAfterOpening, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _birthdayMeta =
      const VerificationMeta('birthday');
  @override
  late final GeneratedColumn<DateTime> birthday = GeneratedColumn<DateTime>(
      'birthday', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastContactedAtMeta =
      const VerificationMeta('lastContactedAt');
  @override
  late final GeneratedColumn<DateTime> lastContactedAt =
      GeneratedColumn<DateTime>('last_contacted_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _reminderIntervalDaysMeta =
      const VerificationMeta('reminderIntervalDays');
  @override
  late final GeneratedColumn<int> reminderIntervalDays = GeneratedColumn<int>(
      'reminder_interval_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        notes,
        photoPath,
        birthday,
        lastContactedAt,
        reminderIntervalDays,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(Insertable<Contact> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('birthday')) {
      context.handle(_birthdayMeta,
          birthday.isAcceptableOrUnknown(data['birthday']!, _birthdayMeta));
    }
    if (data.containsKey('last_contacted_at')) {
      context.handle(
          _lastContactedAtMeta,
          lastContactedAt.isAcceptableOrUnknown(
              data['last_contacted_at']!, _lastContactedAtMeta));
    }
    if (data.containsKey('reminder_interval_days')) {
      context.handle(
          _reminderIntervalDaysMeta,
          reminderIntervalDays.isAcceptableOrUnknown(
              data['reminder_interval_days']!, _reminderIntervalDaysMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      birthday: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}birthday']),
      lastContactedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_contacted_at']),
      reminderIntervalDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}reminder_interval_days']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class Contact extends DataClass implements Insertable<Contact> {
  final String id;
  final String name;
  final String? notes;
  final String? photoPath;
  final DateTime? birthday;
  final DateTime? lastContactedAt;
  final int? reminderIntervalDays;
  final DateTime createdAt;
  const Contact(
      {required this.id,
      required this.name,
      this.notes,
      this.photoPath,
      this.birthday,
      this.lastContactedAt,
      this.reminderIntervalDays,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || birthday != null) {
      map['birthday'] = Variable<DateTime>(birthday);
    }
    if (!nullToAbsent || lastContactedAt != null) {
      map['last_contacted_at'] = Variable<DateTime>(lastContactedAt);
    }
    if (!nullToAbsent || reminderIntervalDays != null) {
      map['reminder_interval_days'] = Variable<int>(reminderIntervalDays);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      id: Value(id),
      name: Value(name),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      birthday: birthday == null && nullToAbsent
          ? const Value.absent()
          : Value(birthday),
      lastContactedAt: lastContactedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastContactedAt),
      reminderIntervalDays: reminderIntervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderIntervalDays),
      createdAt: Value(createdAt),
    );
  }

  factory Contact.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      birthday: serializer.fromJson<DateTime?>(json['birthday']),
      lastContactedAt: serializer.fromJson<DateTime?>(json['lastContactedAt']),
      reminderIntervalDays:
          serializer.fromJson<int?>(json['reminderIntervalDays']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
      'photoPath': serializer.toJson<String?>(photoPath),
      'birthday': serializer.toJson<DateTime?>(birthday),
      'lastContactedAt': serializer.toJson<DateTime?>(lastContactedAt),
      'reminderIntervalDays': serializer.toJson<int?>(reminderIntervalDays),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Contact copyWith(
          {String? id,
          String? name,
          Value<String?> notes = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          Value<DateTime?> birthday = const Value.absent(),
          Value<DateTime?> lastContactedAt = const Value.absent(),
          Value<int?> reminderIntervalDays = const Value.absent(),
          DateTime? createdAt}) =>
      Contact(
        id: id ?? this.id,
        name: name ?? this.name,
        notes: notes.present ? notes.value : this.notes,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        birthday: birthday.present ? birthday.value : this.birthday,
        lastContactedAt: lastContactedAt.present
            ? lastContactedAt.value
            : this.lastContactedAt,
        reminderIntervalDays: reminderIntervalDays.present
            ? reminderIntervalDays.value
            : this.reminderIntervalDays,
        createdAt: createdAt ?? this.createdAt,
      );
  Contact copyWithCompanion(ContactsCompanion data) {
    return Contact(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      birthday: data.birthday.present ? data.birthday.value : this.birthday,
      lastContactedAt: data.lastContactedAt.present
          ? data.lastContactedAt.value
          : this.lastContactedAt,
      reminderIntervalDays: data.reminderIntervalDays.present
          ? data.reminderIntervalDays.value
          : this.reminderIntervalDays,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('birthday: $birthday, ')
          ..write('lastContactedAt: $lastContactedAt, ')
          ..write('reminderIntervalDays: $reminderIntervalDays, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, notes, photoPath, birthday,
      lastContactedAt, reminderIntervalDays, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.id == this.id &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.photoPath == this.photoPath &&
          other.birthday == this.birthday &&
          other.lastContactedAt == this.lastContactedAt &&
          other.reminderIntervalDays == this.reminderIntervalDays &&
          other.createdAt == this.createdAt);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> notes;
  final Value<String?> photoPath;
  final Value<DateTime?> birthday;
  final Value<DateTime?> lastContactedAt;
  final Value<int?> reminderIntervalDays;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ContactsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.birthday = const Value.absent(),
    this.lastContactedAt = const Value.absent(),
    this.reminderIntervalDays = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContactsCompanion.insert({
    required String id,
    required String name,
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.birthday = const Value.absent(),
    this.lastContactedAt = const Value.absent(),
    this.reminderIntervalDays = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Contact> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<String>? photoPath,
    Expression<DateTime>? birthday,
    Expression<DateTime>? lastContactedAt,
    Expression<int>? reminderIntervalDays,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (photoPath != null) 'photo_path': photoPath,
      if (birthday != null) 'birthday': birthday,
      if (lastContactedAt != null) 'last_contacted_at': lastContactedAt,
      if (reminderIntervalDays != null)
        'reminder_interval_days': reminderIntervalDays,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContactsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? notes,
      Value<String?>? photoPath,
      Value<DateTime?>? birthday,
      Value<DateTime?>? lastContactedAt,
      Value<int?>? reminderIntervalDays,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ContactsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      birthday: birthday ?? this.birthday,
      lastContactedAt: lastContactedAt ?? this.lastContactedAt,
      reminderIntervalDays: reminderIntervalDays ?? this.reminderIntervalDays,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<DateTime>(birthday.value);
    }
    if (lastContactedAt.present) {
      map['last_contacted_at'] = Variable<DateTime>(lastContactedAt.value);
    }
    if (reminderIntervalDays.present) {
      map['reminder_interval_days'] = Variable<int>(reminderIntervalDays.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('birthday: $birthday, ')
          ..write('lastContactedAt: $lastContactedAt, ')
          ..write('reminderIntervalDays: $reminderIntervalDays, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EnvelopesTable extends Envelopes
    with TableInfo<$EnvelopesTable, Envelope> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnvelopesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _balanceCentsMeta =
      const VerificationMeta('balanceCents');
  @override
  late final GeneratedColumn<int> balanceCents = GeneratedColumn<int>(
      'balance_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _targetCentsMeta =
      const VerificationMeta('targetCents');
  @override
  late final GeneratedColumn<int> targetCents = GeneratedColumn<int>(
      'target_cents', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, icon, balanceCents, targetCents, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'envelopes';
  @override
  VerificationContext validateIntegrity(Insertable<Envelope> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('balance_cents')) {
      context.handle(
          _balanceCentsMeta,
          balanceCents.isAcceptableOrUnknown(
              data['balance_cents']!, _balanceCentsMeta));
    }
    if (data.containsKey('target_cents')) {
      context.handle(
          _targetCentsMeta,
          targetCents.isAcceptableOrUnknown(
              data['target_cents']!, _targetCentsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Envelope map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Envelope(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      balanceCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}balance_cents'])!,
      targetCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_cents']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EnvelopesTable createAlias(String alias) {
    return $EnvelopesTable(attachedDatabase, alias);
  }
}

class Envelope extends DataClass implements Insertable<Envelope> {
  final String id;
  final String name;
  final String? icon;
  final int balanceCents;

  /// Optionales Ziel-Budget pro Periode, nur für die Statusfarbe.
  /// Ohne target keine Farbe/Fortschrittsbalken – reines "wie viel
  /// ist noch da" ohne Bewertung.
  final int? targetCents;
  final DateTime createdAt;
  const Envelope(
      {required this.id,
      required this.name,
      this.icon,
      required this.balanceCents,
      this.targetCents,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['balance_cents'] = Variable<int>(balanceCents);
    if (!nullToAbsent || targetCents != null) {
      map['target_cents'] = Variable<int>(targetCents);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EnvelopesCompanion toCompanion(bool nullToAbsent) {
    return EnvelopesCompanion(
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      balanceCents: Value(balanceCents),
      targetCents: targetCents == null && nullToAbsent
          ? const Value.absent()
          : Value(targetCents),
      createdAt: Value(createdAt),
    );
  }

  factory Envelope.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Envelope(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      balanceCents: serializer.fromJson<int>(json['balanceCents']),
      targetCents: serializer.fromJson<int?>(json['targetCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'balanceCents': serializer.toJson<int>(balanceCents),
      'targetCents': serializer.toJson<int?>(targetCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Envelope copyWith(
          {String? id,
          String? name,
          Value<String?> icon = const Value.absent(),
          int? balanceCents,
          Value<int?> targetCents = const Value.absent(),
          DateTime? createdAt}) =>
      Envelope(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon.present ? icon.value : this.icon,
        balanceCents: balanceCents ?? this.balanceCents,
        targetCents: targetCents.present ? targetCents.value : this.targetCents,
        createdAt: createdAt ?? this.createdAt,
      );
  Envelope copyWithCompanion(EnvelopesCompanion data) {
    return Envelope(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      balanceCents: data.balanceCents.present
          ? data.balanceCents.value
          : this.balanceCents,
      targetCents:
          data.targetCents.present ? data.targetCents.value : this.targetCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Envelope(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('targetCents: $targetCents, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, icon, balanceCents, targetCents, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Envelope &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.balanceCents == this.balanceCents &&
          other.targetCents == this.targetCents &&
          other.createdAt == this.createdAt);
}

class EnvelopesCompanion extends UpdateCompanion<Envelope> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<int> balanceCents;
  final Value<int?> targetCents;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EnvelopesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.targetCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnvelopesCompanion.insert({
    required String id,
    required String name,
    this.icon = const Value.absent(),
    this.balanceCents = const Value.absent(),
    this.targetCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Envelope> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? balanceCents,
    Expression<int>? targetCents,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (balanceCents != null) 'balance_cents': balanceCents,
      if (targetCents != null) 'target_cents': targetCents,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnvelopesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? icon,
      Value<int>? balanceCents,
      Value<int?>? targetCents,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return EnvelopesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      balanceCents: balanceCents ?? this.balanceCents,
      targetCents: targetCents ?? this.targetCents,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (balanceCents.present) {
      map['balance_cents'] = Variable<int>(balanceCents.value);
    }
    if (targetCents.present) {
      map['target_cents'] = Variable<int>(targetCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('balanceCents: $balanceCents, ')
          ..write('targetCents: $targetCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EnvelopeTransactionsTable extends EnvelopeTransactions
    with TableInfo<$EnvelopeTransactionsTable, EnvelopeTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnvelopeTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _envelopeIdMeta =
      const VerificationMeta('envelopeId');
  @override
  late final GeneratedColumn<String> envelopeId = GeneratedColumn<String>(
      'envelope_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES envelopes (id) ON DELETE CASCADE'));
  static const VerificationMeta _amountCentsMeta =
      const VerificationMeta('amountCents');
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
      'amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, envelopeId, amountCents, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'envelope_transactions';
  @override
  VerificationContext validateIntegrity(
      Insertable<EnvelopeTransaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('envelope_id')) {
      context.handle(
          _envelopeIdMeta,
          envelopeId.isAcceptableOrUnknown(
              data['envelope_id']!, _envelopeIdMeta));
    } else if (isInserting) {
      context.missing(_envelopeIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
          _amountCentsMeta,
          amountCents.isAcceptableOrUnknown(
              data['amount_cents']!, _amountCentsMeta));
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnvelopeTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnvelopeTransaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      envelopeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}envelope_id'])!,
      amountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_cents'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EnvelopeTransactionsTable createAlias(String alias) {
    return $EnvelopeTransactionsTable(attachedDatabase, alias);
  }
}

class EnvelopeTransaction extends DataClass
    implements Insertable<EnvelopeTransaction> {
  final String id;
  final String envelopeId;
  final int amountCents;
  final String? note;
  final DateTime createdAt;
  const EnvelopeTransaction(
      {required this.id,
      required this.envelopeId,
      required this.amountCents,
      this.note,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['envelope_id'] = Variable<String>(envelopeId);
    map['amount_cents'] = Variable<int>(amountCents);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EnvelopeTransactionsCompanion toCompanion(bool nullToAbsent) {
    return EnvelopeTransactionsCompanion(
      id: Value(id),
      envelopeId: Value(envelopeId),
      amountCents: Value(amountCents),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory EnvelopeTransaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnvelopeTransaction(
      id: serializer.fromJson<String>(json['id']),
      envelopeId: serializer.fromJson<String>(json['envelopeId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'envelopeId': serializer.toJson<String>(envelopeId),
      'amountCents': serializer.toJson<int>(amountCents),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EnvelopeTransaction copyWith(
          {String? id,
          String? envelopeId,
          int? amountCents,
          Value<String?> note = const Value.absent(),
          DateTime? createdAt}) =>
      EnvelopeTransaction(
        id: id ?? this.id,
        envelopeId: envelopeId ?? this.envelopeId,
        amountCents: amountCents ?? this.amountCents,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
      );
  EnvelopeTransaction copyWithCompanion(EnvelopeTransactionsCompanion data) {
    return EnvelopeTransaction(
      id: data.id.present ? data.id.value : this.id,
      envelopeId:
          data.envelopeId.present ? data.envelopeId.value : this.envelopeId,
      amountCents:
          data.amountCents.present ? data.amountCents.value : this.amountCents,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopeTransaction(')
          ..write('id: $id, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('amountCents: $amountCents, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, envelopeId, amountCents, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvelopeTransaction &&
          other.id == this.id &&
          other.envelopeId == this.envelopeId &&
          other.amountCents == this.amountCents &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class EnvelopeTransactionsCompanion
    extends UpdateCompanion<EnvelopeTransaction> {
  final Value<String> id;
  final Value<String> envelopeId;
  final Value<int> amountCents;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EnvelopeTransactionsCompanion({
    this.id = const Value.absent(),
    this.envelopeId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnvelopeTransactionsCompanion.insert({
    required String id,
    required String envelopeId,
    required int amountCents,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        envelopeId = Value(envelopeId),
        amountCents = Value(amountCents);
  static Insertable<EnvelopeTransaction> custom({
    Expression<String>? id,
    Expression<String>? envelopeId,
    Expression<int>? amountCents,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (envelopeId != null) 'envelope_id': envelopeId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnvelopeTransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? envelopeId,
      Value<int>? amountCents,
      Value<String?>? note,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return EnvelopeTransactionsCompanion(
      id: id ?? this.id,
      envelopeId: envelopeId ?? this.envelopeId,
      amountCents: amountCents ?? this.amountCents,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (envelopeId.present) {
      map['envelope_id'] = Variable<String>(envelopeId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopeTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('amountCents: $amountCents, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthAppointmentsTable extends HealthAppointments
    with TableInfo<$HealthAppointmentsTable, HealthAppointment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthAppointmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastCompletedAtMeta =
      const VerificationMeta('lastCompletedAt');
  @override
  late final GeneratedColumn<DateTime> lastCompletedAt =
      GeneratedColumn<DateTime>('last_completed_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _institutionMeta =
      const VerificationMeta('institution');
  @override
  late final GeneratedColumn<String> institution = GeneratedColumn<String>(
      'institution', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        intervalDays,
        lastCompletedAt,
        notes,
        institution,
        address,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_appointments';
  @override
  VerificationContext validateIntegrity(Insertable<HealthAppointment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    } else if (isInserting) {
      context.missing(_intervalDaysMeta);
    }
    if (data.containsKey('last_completed_at')) {
      context.handle(
          _lastCompletedAtMeta,
          lastCompletedAt.isAcceptableOrUnknown(
              data['last_completed_at']!, _lastCompletedAtMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('institution')) {
      context.handle(
          _institutionMeta,
          institution.isAcceptableOrUnknown(
              data['institution']!, _institutionMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthAppointment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthAppointment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days'])!,
      lastCompletedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_completed_at']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      institution: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}institution']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $HealthAppointmentsTable createAlias(String alias) {
    return $HealthAppointmentsTable(attachedDatabase, alias);
  }
}

class HealthAppointment extends DataClass
    implements Insertable<HealthAppointment> {
  final String id;
  final String name;
  final int intervalDays;
  final DateTime? lastCompletedAt;
  final String? notes;
  final String? institution;
  final String? address;
  final DateTime createdAt;
  const HealthAppointment(
      {required this.id,
      required this.name,
      required this.intervalDays,
      this.lastCompletedAt,
      this.notes,
      this.institution,
      this.address,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['interval_days'] = Variable<int>(intervalDays);
    if (!nullToAbsent || lastCompletedAt != null) {
      map['last_completed_at'] = Variable<DateTime>(lastCompletedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || institution != null) {
      map['institution'] = Variable<String>(institution);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HealthAppointmentsCompanion toCompanion(bool nullToAbsent) {
    return HealthAppointmentsCompanion(
      id: Value(id),
      name: Value(name),
      intervalDays: Value(intervalDays),
      lastCompletedAt: lastCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      institution: institution == null && nullToAbsent
          ? const Value.absent()
          : Value(institution),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      createdAt: Value(createdAt),
    );
  }

  factory HealthAppointment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthAppointment(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      lastCompletedAt: serializer.fromJson<DateTime?>(json['lastCompletedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      institution: serializer.fromJson<String?>(json['institution']),
      address: serializer.fromJson<String?>(json['address']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'lastCompletedAt': serializer.toJson<DateTime?>(lastCompletedAt),
      'notes': serializer.toJson<String?>(notes),
      'institution': serializer.toJson<String?>(institution),
      'address': serializer.toJson<String?>(address),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HealthAppointment copyWith(
          {String? id,
          String? name,
          int? intervalDays,
          Value<DateTime?> lastCompletedAt = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> institution = const Value.absent(),
          Value<String?> address = const Value.absent(),
          DateTime? createdAt}) =>
      HealthAppointment(
        id: id ?? this.id,
        name: name ?? this.name,
        intervalDays: intervalDays ?? this.intervalDays,
        lastCompletedAt: lastCompletedAt.present
            ? lastCompletedAt.value
            : this.lastCompletedAt,
        notes: notes.present ? notes.value : this.notes,
        institution: institution.present ? institution.value : this.institution,
        address: address.present ? address.value : this.address,
        createdAt: createdAt ?? this.createdAt,
      );
  HealthAppointment copyWithCompanion(HealthAppointmentsCompanion data) {
    return HealthAppointment(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      lastCompletedAt: data.lastCompletedAt.present
          ? data.lastCompletedAt.value
          : this.lastCompletedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      institution:
          data.institution.present ? data.institution.value : this.institution,
      address: data.address.present ? data.address.value : this.address,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthAppointment(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastCompletedAt: $lastCompletedAt, ')
          ..write('notes: $notes, ')
          ..write('institution: $institution, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, intervalDays, lastCompletedAt,
      notes, institution, address, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthAppointment &&
          other.id == this.id &&
          other.name == this.name &&
          other.intervalDays == this.intervalDays &&
          other.lastCompletedAt == this.lastCompletedAt &&
          other.notes == this.notes &&
          other.institution == this.institution &&
          other.address == this.address &&
          other.createdAt == this.createdAt);
}

class HealthAppointmentsCompanion extends UpdateCompanion<HealthAppointment> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> intervalDays;
  final Value<DateTime?> lastCompletedAt;
  final Value<String?> notes;
  final Value<String?> institution;
  final Value<String?> address;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HealthAppointmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.lastCompletedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.institution = const Value.absent(),
    this.address = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthAppointmentsCompanion.insert({
    required String id,
    required String name,
    required int intervalDays,
    this.lastCompletedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.institution = const Value.absent(),
    this.address = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        intervalDays = Value(intervalDays);
  static Insertable<HealthAppointment> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? intervalDays,
    Expression<DateTime>? lastCompletedAt,
    Expression<String>? notes,
    Expression<String>? institution,
    Expression<String>? address,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (lastCompletedAt != null) 'last_completed_at': lastCompletedAt,
      if (notes != null) 'notes': notes,
      if (institution != null) 'institution': institution,
      if (address != null) 'address': address,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthAppointmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? intervalDays,
      Value<DateTime?>? lastCompletedAt,
      Value<String?>? notes,
      Value<String?>? institution,
      Value<String?>? address,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return HealthAppointmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      intervalDays: intervalDays ?? this.intervalDays,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      notes: notes ?? this.notes,
      institution: institution ?? this.institution,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (lastCompletedAt.present) {
      map['last_completed_at'] = Variable<DateTime>(lastCompletedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (institution.present) {
      map['institution'] = Variable<String>(institution.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthAppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastCompletedAt: $lastCompletedAt, ')
          ..write('notes: $notes, ')
          ..write('institution: $institution, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, Medication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dosageNoteMeta =
      const VerificationMeta('dosageNote');
  @override
  late final GeneratedColumn<String> dosageNote = GeneratedColumn<String>(
      'dosage_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timesPerDayMeta =
      const VerificationMeta('timesPerDay');
  @override
  late final GeneratedColumn<int> timesPerDay = GeneratedColumn<int>(
      'times_per_day', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, dosageNote, timesPerDay, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(Insertable<Medication> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dosage_note')) {
      context.handle(
          _dosageNoteMeta,
          dosageNote.isAcceptableOrUnknown(
              data['dosage_note']!, _dosageNoteMeta));
    }
    if (data.containsKey('times_per_day')) {
      context.handle(
          _timesPerDayMeta,
          timesPerDay.isAcceptableOrUnknown(
              data['times_per_day']!, _timesPerDayMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medication(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      dosageNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dosage_note']),
      timesPerDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}times_per_day'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class Medication extends DataClass implements Insertable<Medication> {
  final String id;
  final String name;
  final String? dosageNote;
  final int timesPerDay;
  final DateTime createdAt;
  const Medication(
      {required this.id,
      required this.name,
      this.dosageNote,
      required this.timesPerDay,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dosageNote != null) {
      map['dosage_note'] = Variable<String>(dosageNote);
    }
    map['times_per_day'] = Variable<int>(timesPerDay);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      name: Value(name),
      dosageNote: dosageNote == null && nullToAbsent
          ? const Value.absent()
          : Value(dosageNote),
      timesPerDay: Value(timesPerDay),
      createdAt: Value(createdAt),
    );
  }

  factory Medication.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medication(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dosageNote: serializer.fromJson<String?>(json['dosageNote']),
      timesPerDay: serializer.fromJson<int>(json['timesPerDay']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'dosageNote': serializer.toJson<String?>(dosageNote),
      'timesPerDay': serializer.toJson<int>(timesPerDay),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Medication copyWith(
          {String? id,
          String? name,
          Value<String?> dosageNote = const Value.absent(),
          int? timesPerDay,
          DateTime? createdAt}) =>
      Medication(
        id: id ?? this.id,
        name: name ?? this.name,
        dosageNote: dosageNote.present ? dosageNote.value : this.dosageNote,
        timesPerDay: timesPerDay ?? this.timesPerDay,
        createdAt: createdAt ?? this.createdAt,
      );
  Medication copyWithCompanion(MedicationsCompanion data) {
    return Medication(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dosageNote:
          data.dosageNote.present ? data.dosageNote.value : this.dosageNote,
      timesPerDay:
          data.timesPerDay.present ? data.timesPerDay.value : this.timesPerDay,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medication(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dosageNote: $dosageNote, ')
          ..write('timesPerDay: $timesPerDay, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, dosageNote, timesPerDay, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medication &&
          other.id == this.id &&
          other.name == this.name &&
          other.dosageNote == this.dosageNote &&
          other.timesPerDay == this.timesPerDay &&
          other.createdAt == this.createdAt);
}

class MedicationsCompanion extends UpdateCompanion<Medication> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> dosageNote;
  final Value<int> timesPerDay;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dosageNote = const Value.absent(),
    this.timesPerDay = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    required String id,
    required String name,
    this.dosageNote = const Value.absent(),
    this.timesPerDay = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Medication> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? dosageNote,
    Expression<int>? timesPerDay,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dosageNote != null) 'dosage_note': dosageNote,
      if (timesPerDay != null) 'times_per_day': timesPerDay,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? dosageNote,
      Value<int>? timesPerDay,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return MedicationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dosageNote: dosageNote ?? this.dosageNote,
      timesPerDay: timesPerDay ?? this.timesPerDay,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dosageNote.present) {
      map['dosage_note'] = Variable<String>(dosageNote.value);
    }
    if (timesPerDay.present) {
      map['times_per_day'] = Variable<int>(timesPerDay.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dosageNote: $dosageNote, ')
          ..write('timesPerDay: $timesPerDay, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicationIntakeLogsTable extends MedicationIntakeLogs
    with TableInfo<$MedicationIntakeLogsTable, MedicationIntakeLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationIntakeLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicationIdMeta =
      const VerificationMeta('medicationId');
  @override
  late final GeneratedColumn<String> medicationId = GeneratedColumn<String>(
      'medication_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES medications (id) ON DELETE CASCADE'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _takenCountMeta =
      const VerificationMeta('takenCount');
  @override
  late final GeneratedColumn<int> takenCount = GeneratedColumn<int>(
      'taken_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, medicationId, date, takenCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_intake_logs';
  @override
  VerificationContext validateIntegrity(
      Insertable<MedicationIntakeLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('medication_id')) {
      context.handle(
          _medicationIdMeta,
          medicationId.isAcceptableOrUnknown(
              data['medication_id']!, _medicationIdMeta));
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('taken_count')) {
      context.handle(
          _takenCountMeta,
          takenCount.isAcceptableOrUnknown(
              data['taken_count']!, _takenCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationIntakeLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationIntakeLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      medicationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medication_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      takenCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}taken_count'])!,
    );
  }

  @override
  $MedicationIntakeLogsTable createAlias(String alias) {
    return $MedicationIntakeLogsTable(attachedDatabase, alias);
  }
}

class MedicationIntakeLog extends DataClass
    implements Insertable<MedicationIntakeLog> {
  final String id;
  final String medicationId;
  final DateTime date;
  final int takenCount;
  const MedicationIntakeLog(
      {required this.id,
      required this.medicationId,
      required this.date,
      required this.takenCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medication_id'] = Variable<String>(medicationId);
    map['date'] = Variable<DateTime>(date);
    map['taken_count'] = Variable<int>(takenCount);
    return map;
  }

  MedicationIntakeLogsCompanion toCompanion(bool nullToAbsent) {
    return MedicationIntakeLogsCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      date: Value(date),
      takenCount: Value(takenCount),
    );
  }

  factory MedicationIntakeLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationIntakeLog(
      id: serializer.fromJson<String>(json['id']),
      medicationId: serializer.fromJson<String>(json['medicationId']),
      date: serializer.fromJson<DateTime>(json['date']),
      takenCount: serializer.fromJson<int>(json['takenCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicationId': serializer.toJson<String>(medicationId),
      'date': serializer.toJson<DateTime>(date),
      'takenCount': serializer.toJson<int>(takenCount),
    };
  }

  MedicationIntakeLog copyWith(
          {String? id,
          String? medicationId,
          DateTime? date,
          int? takenCount}) =>
      MedicationIntakeLog(
        id: id ?? this.id,
        medicationId: medicationId ?? this.medicationId,
        date: date ?? this.date,
        takenCount: takenCount ?? this.takenCount,
      );
  MedicationIntakeLog copyWithCompanion(MedicationIntakeLogsCompanion data) {
    return MedicationIntakeLog(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      date: data.date.present ? data.date.value : this.date,
      takenCount:
          data.takenCount.present ? data.takenCount.value : this.takenCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationIntakeLog(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('date: $date, ')
          ..write('takenCount: $takenCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, medicationId, date, takenCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationIntakeLog &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.date == this.date &&
          other.takenCount == this.takenCount);
}

class MedicationIntakeLogsCompanion
    extends UpdateCompanion<MedicationIntakeLog> {
  final Value<String> id;
  final Value<String> medicationId;
  final Value<DateTime> date;
  final Value<int> takenCount;
  final Value<int> rowid;
  const MedicationIntakeLogsCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.date = const Value.absent(),
    this.takenCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationIntakeLogsCompanion.insert({
    required String id,
    required String medicationId,
    required DateTime date,
    this.takenCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        medicationId = Value(medicationId),
        date = Value(date);
  static Insertable<MedicationIntakeLog> custom({
    Expression<String>? id,
    Expression<String>? medicationId,
    Expression<DateTime>? date,
    Expression<int>? takenCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (date != null) 'date': date,
      if (takenCount != null) 'taken_count': takenCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationIntakeLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? medicationId,
      Value<DateTime>? date,
      Value<int>? takenCount,
      Value<int>? rowid}) {
    return MedicationIntakeLogsCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      date: date ?? this.date,
      takenCount: takenCount ?? this.takenCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<String>(medicationId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (takenCount.present) {
      map['taken_count'] = Variable<int>(takenCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationIntakeLogsCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('date: $date, ')
          ..write('takenCount: $takenCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StorageLocationsTable extends StorageLocations
    with TableInfo<$StorageLocationsTable, StorageLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StorageLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
      'item_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, itemName, location, notes, photoPath, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'storage_locations';
  @override
  VerificationContext validateIntegrity(Insertable<StorageLocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StorageLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StorageLocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $StorageLocationsTable createAlias(String alias) {
    return $StorageLocationsTable(attachedDatabase, alias);
  }
}

class StorageLocation extends DataClass implements Insertable<StorageLocation> {
  final String id;
  final String itemName;
  final String location;
  final String? notes;
  final String? photoPath;
  final DateTime createdAt;
  const StorageLocation(
      {required this.id,
      required this.itemName,
      required this.location,
      this.notes,
      this.photoPath,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['item_name'] = Variable<String>(itemName);
    map['location'] = Variable<String>(location);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StorageLocationsCompanion toCompanion(bool nullToAbsent) {
    return StorageLocationsCompanion(
      id: Value(id),
      itemName: Value(itemName),
      location: Value(location),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
    );
  }

  factory StorageLocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StorageLocation(
      id: serializer.fromJson<String>(json['id']),
      itemName: serializer.fromJson<String>(json['itemName']),
      location: serializer.fromJson<String>(json['location']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'itemName': serializer.toJson<String>(itemName),
      'location': serializer.toJson<String>(location),
      'notes': serializer.toJson<String?>(notes),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StorageLocation copyWith(
          {String? id,
          String? itemName,
          String? location,
          Value<String?> notes = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          DateTime? createdAt}) =>
      StorageLocation(
        id: id ?? this.id,
        itemName: itemName ?? this.itemName,
        location: location ?? this.location,
        notes: notes.present ? notes.value : this.notes,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        createdAt: createdAt ?? this.createdAt,
      );
  StorageLocation copyWithCompanion(StorageLocationsCompanion data) {
    return StorageLocation(
      id: data.id.present ? data.id.value : this.id,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      location: data.location.present ? data.location.value : this.location,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StorageLocation(')
          ..write('id: $id, ')
          ..write('itemName: $itemName, ')
          ..write('location: $location, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, itemName, location, notes, photoPath, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StorageLocation &&
          other.id == this.id &&
          other.itemName == this.itemName &&
          other.location == this.location &&
          other.notes == this.notes &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt);
}

class StorageLocationsCompanion extends UpdateCompanion<StorageLocation> {
  final Value<String> id;
  final Value<String> itemName;
  final Value<String> location;
  final Value<String?> notes;
  final Value<String?> photoPath;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StorageLocationsCompanion({
    this.id = const Value.absent(),
    this.itemName = const Value.absent(),
    this.location = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StorageLocationsCompanion.insert({
    required String id,
    required String itemName,
    required String location,
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        itemName = Value(itemName),
        location = Value(location);
  static Insertable<StorageLocation> custom({
    Expression<String>? id,
    Expression<String>? itemName,
    Expression<String>? location,
    Expression<String>? notes,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemName != null) 'item_name': itemName,
      if (location != null) 'location': location,
      if (notes != null) 'notes': notes,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StorageLocationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? itemName,
      Value<String>? location,
      Value<String?>? notes,
      Value<String?>? photoPath,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return StorageLocationsCompanion(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StorageLocationsCompanion(')
          ..write('id: $id, ')
          ..write('itemName: $itemName, ')
          ..write('location: $location, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HouseholdTasksTable householdTasks = $HouseholdTasksTable(this);
  late final $TaskCompletionLogsTable taskCompletionLogs =
      $TaskCompletionLogsTable(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $RoutineItemsTable routineItems = $RoutineItemsTable(this);
  late final $RoutineCompletionsTable routineCompletions =
      $RoutineCompletionsTable(this);
  late final $BrainDumpEntriesTable brainDumpEntries =
      $BrainDumpEntriesTable(this);
  late final $PantryItemsTable pantryItems = $PantryItemsTable(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  late final $EnvelopesTable envelopes = $EnvelopesTable(this);
  late final $EnvelopeTransactionsTable envelopeTransactions =
      $EnvelopeTransactionsTable(this);
  late final $HealthAppointmentsTable healthAppointments =
      $HealthAppointmentsTable(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $MedicationIntakeLogsTable medicationIntakeLogs =
      $MedicationIntakeLogsTable(this);
  late final $StorageLocationsTable storageLocations =
      $StorageLocationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        householdTasks,
        taskCompletionLogs,
        routines,
        routineItems,
        routineCompletions,
        brainDumpEntries,
        pantryItems,
        contacts,
        envelopes,
        envelopeTransactions,
        healthAppointments,
        medications,
        medicationIntakeLogs,
        storageLocations
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('household_tasks',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('task_completion_logs', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('routines',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('routine_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('routines',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('routine_completions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('envelopes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('envelope_transactions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('medications',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('medication_intake_logs', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$HouseholdTasksTableCreateCompanionBuilder = HouseholdTasksCompanion
    Function({
  required String id,
  required String name,
  Value<String?> icon,
  required int intervalDays,
  Value<DateTime?> lastCompletedAt,
  Value<String?> category,
  Value<bool> notificationsEnabled,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$HouseholdTasksTableUpdateCompanionBuilder = HouseholdTasksCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> icon,
  Value<int> intervalDays,
  Value<DateTime?> lastCompletedAt,
  Value<String?> category,
  Value<bool> notificationsEnabled,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$HouseholdTasksTableReferences
    extends BaseReferences<_$AppDatabase, $HouseholdTasksTable, HouseholdTask> {
  $$HouseholdTasksTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TaskCompletionLogsTable, List<TaskCompletionLog>>
      _taskCompletionLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.taskCompletionLogs,
              aliasName: 'household_tasks__id__task_completion_logs__task_id');

  $$TaskCompletionLogsTableProcessedTableManager get taskCompletionLogsRefs {
    final manager =
        $$TaskCompletionLogsTableTableManager($_db, $_db.taskCompletionLogs)
            .filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_taskCompletionLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HouseholdTasksTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdTasksTable> {
  $$HouseholdTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastCompletedAt => $composableBuilder(
      column: $table.lastCompletedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> taskCompletionLogsRefs(
      Expression<bool> Function($$TaskCompletionLogsTableFilterComposer f) f) {
    final $$TaskCompletionLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskCompletionLogs,
        getReferencedColumn: (t) => t.taskId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaskCompletionLogsTableFilterComposer(
              $db: $db,
              $table: $db.taskCompletionLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HouseholdTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdTasksTable> {
  $$HouseholdTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastCompletedAt => $composableBuilder(
      column: $table.lastCompletedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$HouseholdTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdTasksTable> {
  $$HouseholdTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCompletedAt => $composableBuilder(
      column: $table.lastCompletedAt, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> taskCompletionLogsRefs<T extends Object>(
      Expression<T> Function($$TaskCompletionLogsTableAnnotationComposer a) f) {
    final $$TaskCompletionLogsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.taskCompletionLogs,
            getReferencedColumn: (t) => t.taskId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$TaskCompletionLogsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.taskCompletionLogs,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$HouseholdTasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdTasksTable,
    HouseholdTask,
    $$HouseholdTasksTableFilterComposer,
    $$HouseholdTasksTableOrderingComposer,
    $$HouseholdTasksTableAnnotationComposer,
    $$HouseholdTasksTableCreateCompanionBuilder,
    $$HouseholdTasksTableUpdateCompanionBuilder,
    (HouseholdTask, $$HouseholdTasksTableReferences),
    HouseholdTask,
    PrefetchHooks Function({bool taskCompletionLogsRefs})> {
  $$HouseholdTasksTableTableManager(
      _$AppDatabase db, $HouseholdTasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<DateTime?> lastCompletedAt = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdTasksCompanion(
            id: id,
            name: name,
            icon: icon,
            intervalDays: intervalDays,
            lastCompletedAt: lastCompletedAt,
            category: category,
            notificationsEnabled: notificationsEnabled,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> icon = const Value.absent(),
            required int intervalDays,
            Value<DateTime?> lastCompletedAt = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdTasksCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            intervalDays: intervalDays,
            lastCompletedAt: lastCompletedAt,
            category: category,
            notificationsEnabled: notificationsEnabled,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$HouseholdTasksTable, HouseholdTask>(table),
                    $$HouseholdTasksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({taskCompletionLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (taskCompletionLogsRefs) db.taskCompletionLogs
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskCompletionLogsRefs)
                    await $_getPrefetchedData<HouseholdTask,
                            $HouseholdTasksTable, TaskCompletionLog>(
                        currentTable: table,
                        referencedTable: $$HouseholdTasksTableReferences
                            ._taskCompletionLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdTasksTableReferences(db, table, p0)
                                .taskCompletionLogsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.taskId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HouseholdTasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseholdTasksTable,
    HouseholdTask,
    $$HouseholdTasksTableFilterComposer,
    $$HouseholdTasksTableOrderingComposer,
    $$HouseholdTasksTableAnnotationComposer,
    $$HouseholdTasksTableCreateCompanionBuilder,
    $$HouseholdTasksTableUpdateCompanionBuilder,
    (HouseholdTask, $$HouseholdTasksTableReferences),
    HouseholdTask,
    PrefetchHooks Function({bool taskCompletionLogsRefs})>;
typedef $$TaskCompletionLogsTableCreateCompanionBuilder
    = TaskCompletionLogsCompanion Function({
  required String id,
  required String taskId,
  required DateTime completedAt,
  Value<int> rowid,
});
typedef $$TaskCompletionLogsTableUpdateCompanionBuilder
    = TaskCompletionLogsCompanion Function({
  Value<String> id,
  Value<String> taskId,
  Value<DateTime> completedAt,
  Value<int> rowid,
});

final class $$TaskCompletionLogsTableReferences extends BaseReferences<
    _$AppDatabase, $TaskCompletionLogsTable, TaskCompletionLog> {
  $$TaskCompletionLogsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdTasksTable _taskIdTable(_$AppDatabase db) =>
      db.householdTasks
          .createAlias('task_completion_logs__task_id__household_tasks__id');

  $$HouseholdTasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$HouseholdTasksTableTableManager($_db, $_db.householdTasks)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TaskCompletionLogsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskCompletionLogsTable> {
  $$TaskCompletionLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  $$HouseholdTasksTableFilterComposer get taskId {
    final $$HouseholdTasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.householdTasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdTasksTableFilterComposer(
              $db: $db,
              $table: $db.householdTasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskCompletionLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskCompletionLogsTable> {
  $$TaskCompletionLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  $$HouseholdTasksTableOrderingComposer get taskId {
    final $$HouseholdTasksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.householdTasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdTasksTableOrderingComposer(
              $db: $db,
              $table: $db.householdTasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskCompletionLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskCompletionLogsTable> {
  $$TaskCompletionLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  $$HouseholdTasksTableAnnotationComposer get taskId {
    final $$HouseholdTasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.householdTasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdTasksTableAnnotationComposer(
              $db: $db,
              $table: $db.householdTasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskCompletionLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskCompletionLogsTable,
    TaskCompletionLog,
    $$TaskCompletionLogsTableFilterComposer,
    $$TaskCompletionLogsTableOrderingComposer,
    $$TaskCompletionLogsTableAnnotationComposer,
    $$TaskCompletionLogsTableCreateCompanionBuilder,
    $$TaskCompletionLogsTableUpdateCompanionBuilder,
    (TaskCompletionLog, $$TaskCompletionLogsTableReferences),
    TaskCompletionLog,
    PrefetchHooks Function({bool taskId})> {
  $$TaskCompletionLogsTableTableManager(
      _$AppDatabase db, $TaskCompletionLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskCompletionLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskCompletionLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskCompletionLogsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskCompletionLogsCompanion(
            id: id,
            taskId: taskId,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskId,
            required DateTime completedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskCompletionLogsCompanion.insert(
            id: id,
            taskId: taskId,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$TaskCompletionLogsTable, TaskCompletionLog>(
                        table),
                    $$TaskCompletionLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (taskId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.taskId,
                    referencedTable:
                        $$TaskCompletionLogsTableReferences._taskIdTable(db),
                    referencedColumn:
                        $$TaskCompletionLogsTableReferences._taskIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TaskCompletionLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaskCompletionLogsTable,
    TaskCompletionLog,
    $$TaskCompletionLogsTableFilterComposer,
    $$TaskCompletionLogsTableOrderingComposer,
    $$TaskCompletionLogsTableAnnotationComposer,
    $$TaskCompletionLogsTableCreateCompanionBuilder,
    $$TaskCompletionLogsTableUpdateCompanionBuilder,
    (TaskCompletionLog, $$TaskCompletionLogsTableReferences),
    TaskCompletionLog,
    PrefetchHooks Function({bool taskId})>;
typedef $$RoutinesTableCreateCompanionBuilder = RoutinesCompanion Function({
  required String id,
  required String name,
  required String type,
  Value<bool> streakEnabled,
  Value<int> rowid,
});
typedef $$RoutinesTableUpdateCompanionBuilder = RoutinesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<bool> streakEnabled,
  Value<int> rowid,
});

final class $$RoutinesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutinesTable, Routine> {
  $$RoutinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutineItemsTable, List<RoutineItem>>
      _routineItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.routineItems,
              aliasName: 'routines__id__routine_items__routine_id');

  $$RoutineItemsTableProcessedTableManager get routineItemsRefs {
    final manager = $$RoutineItemsTableTableManager($_db, $_db.routineItems)
        .filter((f) => f.routineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_routineItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RoutineCompletionsTable, List<RoutineCompletion>>
      _routineCompletionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.routineCompletions,
              aliasName: 'routines__id__routine_completions__routine_id');

  $$RoutineCompletionsTableProcessedTableManager get routineCompletionsRefs {
    final manager = $$RoutineCompletionsTableTableManager(
            $_db, $_db.routineCompletions)
        .filter((f) => f.routineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_routineCompletionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get streakEnabled => $composableBuilder(
      column: $table.streakEnabled, builder: (column) => ColumnFilters(column));

  Expression<bool> routineItemsRefs(
      Expression<bool> Function($$RoutineItemsTableFilterComposer f) f) {
    final $$RoutineItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.routineItems,
        getReferencedColumn: (t) => t.routineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineItemsTableFilterComposer(
              $db: $db,
              $table: $db.routineItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> routineCompletionsRefs(
      Expression<bool> Function($$RoutineCompletionsTableFilterComposer f) f) {
    final $$RoutineCompletionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.routineCompletions,
        getReferencedColumn: (t) => t.routineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineCompletionsTableFilterComposer(
              $db: $db,
              $table: $db.routineCompletions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get streakEnabled => $composableBuilder(
      column: $table.streakEnabled,
      builder: (column) => ColumnOrderings(column));
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get streakEnabled => $composableBuilder(
      column: $table.streakEnabled, builder: (column) => column);

  Expression<T> routineItemsRefs<T extends Object>(
      Expression<T> Function($$RoutineItemsTableAnnotationComposer a) f) {
    final $$RoutineItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.routineItems,
        getReferencedColumn: (t) => t.routineId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutineItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.routineItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> routineCompletionsRefs<T extends Object>(
      Expression<T> Function($$RoutineCompletionsTableAnnotationComposer a) f) {
    final $$RoutineCompletionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.routineCompletions,
            getReferencedColumn: (t) => t.routineId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RoutineCompletionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.routineCompletions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$RoutinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutinesTable,
    Routine,
    $$RoutinesTableFilterComposer,
    $$RoutinesTableOrderingComposer,
    $$RoutinesTableAnnotationComposer,
    $$RoutinesTableCreateCompanionBuilder,
    $$RoutinesTableUpdateCompanionBuilder,
    (Routine, $$RoutinesTableReferences),
    Routine,
    PrefetchHooks Function(
        {bool routineItemsRefs, bool routineCompletionsRefs})> {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<bool> streakEnabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutinesCompanion(
            id: id,
            name: name,
            type: type,
            streakEnabled: streakEnabled,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            Value<bool> streakEnabled = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutinesCompanion.insert(
            id: id,
            name: name,
            type: type,
            streakEnabled: streakEnabled,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RoutinesTable, Routine>(table),
                    $$RoutinesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {routineItemsRefs = false, routineCompletionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (routineItemsRefs) db.routineItems,
                if (routineCompletionsRefs) db.routineCompletions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routineItemsRefs)
                    await $_getPrefetchedData<Routine, $RoutinesTable,
                            RoutineItem>(
                        currentTable: table,
                        referencedTable: $$RoutinesTableReferences
                            ._routineItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RoutinesTableReferences(db, table, p0)
                                .routineItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.routineId == item.id),
                        typedResults: items),
                  if (routineCompletionsRefs)
                    await $_getPrefetchedData<Routine, $RoutinesTable,
                            RoutineCompletion>(
                        currentTable: table,
                        referencedTable: $$RoutinesTableReferences
                            ._routineCompletionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RoutinesTableReferences(db, table, p0)
                                .routineCompletionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.routineId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RoutinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutinesTable,
    Routine,
    $$RoutinesTableFilterComposer,
    $$RoutinesTableOrderingComposer,
    $$RoutinesTableAnnotationComposer,
    $$RoutinesTableCreateCompanionBuilder,
    $$RoutinesTableUpdateCompanionBuilder,
    (Routine, $$RoutinesTableReferences),
    Routine,
    PrefetchHooks Function(
        {bool routineItemsRefs, bool routineCompletionsRefs})>;
typedef $$RoutineItemsTableCreateCompanionBuilder = RoutineItemsCompanion
    Function({
  required String id,
  required String routineId,
  required String label,
  required int sortOrder,
  Value<String?> icon,
  Value<int> rowid,
});
typedef $$RoutineItemsTableUpdateCompanionBuilder = RoutineItemsCompanion
    Function({
  Value<String> id,
  Value<String> routineId,
  Value<String> label,
  Value<int> sortOrder,
  Value<String?> icon,
  Value<int> rowid,
});

final class $$RoutineItemsTableReferences
    extends BaseReferences<_$AppDatabase, $RoutineItemsTable, RoutineItem> {
  $$RoutineItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('routine_items__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<String>('routine_id')!;

    final manager = $$RoutinesTableTableManager($_db, $_db.routines)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RoutineItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.routineId,
        referencedTable: $db.routines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutinesTableFilterComposer(
              $db: $db,
              $table: $db.routines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.routineId,
        referencedTable: $db.routines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutinesTableOrderingComposer(
              $db: $db,
              $table: $db.routines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineItemsTable> {
  $$RoutineItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.routineId,
        referencedTable: $db.routines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutinesTableAnnotationComposer(
              $db: $db,
              $table: $db.routines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutineItemsTable,
    RoutineItem,
    $$RoutineItemsTableFilterComposer,
    $$RoutineItemsTableOrderingComposer,
    $$RoutineItemsTableAnnotationComposer,
    $$RoutineItemsTableCreateCompanionBuilder,
    $$RoutineItemsTableUpdateCompanionBuilder,
    (RoutineItem, $$RoutineItemsTableReferences),
    RoutineItem,
    PrefetchHooks Function({bool routineId})> {
  $$RoutineItemsTableTableManager(_$AppDatabase db, $RoutineItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> routineId = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineItemsCompanion(
            id: id,
            routineId: routineId,
            label: label,
            sortOrder: sortOrder,
            icon: icon,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String routineId,
            required String label,
            required int sortOrder,
            Value<String?> icon = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineItemsCompanion.insert(
            id: id,
            routineId: routineId,
            label: label,
            sortOrder: sortOrder,
            icon: icon,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RoutineItemsTable, RoutineItem>(table),
                    $$RoutineItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({routineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (routineId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.routineId,
                    referencedTable:
                        $$RoutineItemsTableReferences._routineIdTable(db),
                    referencedColumn:
                        $$RoutineItemsTableReferences._routineIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RoutineItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutineItemsTable,
    RoutineItem,
    $$RoutineItemsTableFilterComposer,
    $$RoutineItemsTableOrderingComposer,
    $$RoutineItemsTableAnnotationComposer,
    $$RoutineItemsTableCreateCompanionBuilder,
    $$RoutineItemsTableUpdateCompanionBuilder,
    (RoutineItem, $$RoutineItemsTableReferences),
    RoutineItem,
    PrefetchHooks Function({bool routineId})>;
typedef $$RoutineCompletionsTableCreateCompanionBuilder
    = RoutineCompletionsCompanion Function({
  required String id,
  required String routineId,
  required DateTime date,
  required String completedItemIds,
  Value<bool> fullyCompleted,
  Value<int> rowid,
});
typedef $$RoutineCompletionsTableUpdateCompanionBuilder
    = RoutineCompletionsCompanion Function({
  Value<String> id,
  Value<String> routineId,
  Value<DateTime> date,
  Value<String> completedItemIds,
  Value<bool> fullyCompleted,
  Value<int> rowid,
});

final class $$RoutineCompletionsTableReferences extends BaseReferences<
    _$AppDatabase, $RoutineCompletionsTable, RoutineCompletion> {
  $$RoutineCompletionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('routine_completions__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<String>('routine_id')!;

    final manager = $$RoutinesTableTableManager($_db, $_db.routines)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RoutineCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineCompletionsTable> {
  $$RoutineCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get completedItemIds => $composableBuilder(
      column: $table.completedItemIds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get fullyCompleted => $composableBuilder(
      column: $table.fullyCompleted,
      builder: (column) => ColumnFilters(column));

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.routineId,
        referencedTable: $db.routines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutinesTableFilterComposer(
              $db: $db,
              $table: $db.routines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineCompletionsTable> {
  $$RoutineCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get completedItemIds => $composableBuilder(
      column: $table.completedItemIds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get fullyCompleted => $composableBuilder(
      column: $table.fullyCompleted,
      builder: (column) => ColumnOrderings(column));

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.routineId,
        referencedTable: $db.routines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutinesTableOrderingComposer(
              $db: $db,
              $table: $db.routines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineCompletionsTable> {
  $$RoutineCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get completedItemIds => $composableBuilder(
      column: $table.completedItemIds, builder: (column) => column);

  GeneratedColumn<bool> get fullyCompleted => $composableBuilder(
      column: $table.fullyCompleted, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.routineId,
        referencedTable: $db.routines,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RoutinesTableAnnotationComposer(
              $db: $db,
              $table: $db.routines,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RoutineCompletionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutineCompletionsTable,
    RoutineCompletion,
    $$RoutineCompletionsTableFilterComposer,
    $$RoutineCompletionsTableOrderingComposer,
    $$RoutineCompletionsTableAnnotationComposer,
    $$RoutineCompletionsTableCreateCompanionBuilder,
    $$RoutineCompletionsTableUpdateCompanionBuilder,
    (RoutineCompletion, $$RoutineCompletionsTableReferences),
    RoutineCompletion,
    PrefetchHooks Function({bool routineId})> {
  $$RoutineCompletionsTableTableManager(
      _$AppDatabase db, $RoutineCompletionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineCompletionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> routineId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> completedItemIds = const Value.absent(),
            Value<bool> fullyCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineCompletionsCompanion(
            id: id,
            routineId: routineId,
            date: date,
            completedItemIds: completedItemIds,
            fullyCompleted: fullyCompleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String routineId,
            required DateTime date,
            required String completedItemIds,
            Value<bool> fullyCompleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutineCompletionsCompanion.insert(
            id: id,
            routineId: routineId,
            date: date,
            completedItemIds: completedItemIds,
            fullyCompleted: fullyCompleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RoutineCompletionsTable, RoutineCompletion>(
                        table),
                    $$RoutineCompletionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({routineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (routineId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.routineId,
                    referencedTable:
                        $$RoutineCompletionsTableReferences._routineIdTable(db),
                    referencedColumn: $$RoutineCompletionsTableReferences
                        ._routineIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RoutineCompletionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutineCompletionsTable,
    RoutineCompletion,
    $$RoutineCompletionsTableFilterComposer,
    $$RoutineCompletionsTableOrderingComposer,
    $$RoutineCompletionsTableAnnotationComposer,
    $$RoutineCompletionsTableCreateCompanionBuilder,
    $$RoutineCompletionsTableUpdateCompanionBuilder,
    (RoutineCompletion, $$RoutineCompletionsTableReferences),
    RoutineCompletion,
    PrefetchHooks Function({bool routineId})>;
typedef $$BrainDumpEntriesTableCreateCompanionBuilder
    = BrainDumpEntriesCompanion Function({
  required String id,
  required String content,
  Value<DateTime> createdAt,
  Value<bool> done,
  Value<String?> category,
  Value<int> priority,
  Value<bool> pinned,
  Value<int> rowid,
});
typedef $$BrainDumpEntriesTableUpdateCompanionBuilder
    = BrainDumpEntriesCompanion Function({
  Value<String> id,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<bool> done,
  Value<String?> category,
  Value<int> priority,
  Value<bool> pinned,
  Value<int> rowid,
});

class $$BrainDumpEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $BrainDumpEntriesTable> {
  $$BrainDumpEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get done => $composableBuilder(
      column: $table.done, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnFilters(column));
}

class $$BrainDumpEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BrainDumpEntriesTable> {
  $$BrainDumpEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get done => $composableBuilder(
      column: $table.done, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnOrderings(column));
}

class $$BrainDumpEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrainDumpEntriesTable> {
  $$BrainDumpEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => column);
}

class $$BrainDumpEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BrainDumpEntriesTable,
    BrainDumpEntry,
    $$BrainDumpEntriesTableFilterComposer,
    $$BrainDumpEntriesTableOrderingComposer,
    $$BrainDumpEntriesTableAnnotationComposer,
    $$BrainDumpEntriesTableCreateCompanionBuilder,
    $$BrainDumpEntriesTableUpdateCompanionBuilder,
    (
      BrainDumpEntry,
      BaseReferences<_$AppDatabase, $BrainDumpEntriesTable, BrainDumpEntry>
    ),
    BrainDumpEntry,
    PrefetchHooks Function()> {
  $$BrainDumpEntriesTableTableManager(
      _$AppDatabase db, $BrainDumpEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrainDumpEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrainDumpEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrainDumpEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> done = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<bool> pinned = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BrainDumpEntriesCompanion(
            id: id,
            content: content,
            createdAt: createdAt,
            done: done,
            category: category,
            priority: priority,
            pinned: pinned,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String content,
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> done = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<bool> pinned = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BrainDumpEntriesCompanion.insert(
            id: id,
            content: content,
            createdAt: createdAt,
            done: done,
            category: category,
            priority: priority,
            pinned: pinned,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$BrainDumpEntriesTable, BrainDumpEntry>(table),
                    BaseReferences<_$AppDatabase, $BrainDumpEntriesTable,
                        BrainDumpEntry>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BrainDumpEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BrainDumpEntriesTable,
    BrainDumpEntry,
    $$BrainDumpEntriesTableFilterComposer,
    $$BrainDumpEntriesTableOrderingComposer,
    $$BrainDumpEntriesTableAnnotationComposer,
    $$BrainDumpEntriesTableCreateCompanionBuilder,
    $$BrainDumpEntriesTableUpdateCompanionBuilder,
    (
      BrainDumpEntry,
      BaseReferences<_$AppDatabase, $BrainDumpEntriesTable, BrainDumpEntry>
    ),
    BrainDumpEntry,
    PrefetchHooks Function()>;
typedef $$PantryItemsTableCreateCompanionBuilder = PantryItemsCompanion
    Function({
  required String id,
  required String name,
  Value<String?> icon,
  Value<String?> category,
  required DateTime expiryDate,
  Value<DateTime?> openedAt,
  Value<int?> daysGoodAfterOpening,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$PantryItemsTableUpdateCompanionBuilder = PantryItemsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> icon,
  Value<String?> category,
  Value<DateTime> expiryDate,
  Value<DateTime?> openedAt,
  Value<int?> daysGoodAfterOpening,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$PantryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PantryItemsTable> {
  $$PantryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get daysGoodAfterOpening => $composableBuilder(
      column: $table.daysGoodAfterOpening,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PantryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PantryItemsTable> {
  $$PantryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get daysGoodAfterOpening => $composableBuilder(
      column: $table.daysGoodAfterOpening,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PantryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PantryItemsTable> {
  $$PantryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<int> get daysGoodAfterOpening => $composableBuilder(
      column: $table.daysGoodAfterOpening, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PantryItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PantryItemsTable,
    PantryItem,
    $$PantryItemsTableFilterComposer,
    $$PantryItemsTableOrderingComposer,
    $$PantryItemsTableAnnotationComposer,
    $$PantryItemsTableCreateCompanionBuilder,
    $$PantryItemsTableUpdateCompanionBuilder,
    (PantryItem, BaseReferences<_$AppDatabase, $PantryItemsTable, PantryItem>),
    PantryItem,
    PrefetchHooks Function()> {
  $$PantryItemsTableTableManager(_$AppDatabase db, $PantryItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PantryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PantryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PantryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<DateTime> expiryDate = const Value.absent(),
            Value<DateTime?> openedAt = const Value.absent(),
            Value<int?> daysGoodAfterOpening = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PantryItemsCompanion(
            id: id,
            name: name,
            icon: icon,
            category: category,
            expiryDate: expiryDate,
            openedAt: openedAt,
            daysGoodAfterOpening: daysGoodAfterOpening,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> icon = const Value.absent(),
            Value<String?> category = const Value.absent(),
            required DateTime expiryDate,
            Value<DateTime?> openedAt = const Value.absent(),
            Value<int?> daysGoodAfterOpening = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PantryItemsCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            category: category,
            expiryDate: expiryDate,
            openedAt: openedAt,
            daysGoodAfterOpening: daysGoodAfterOpening,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PantryItemsTable, PantryItem>(table),
                    BaseReferences<_$AppDatabase, $PantryItemsTable,
                        PantryItem>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PantryItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PantryItemsTable,
    PantryItem,
    $$PantryItemsTableFilterComposer,
    $$PantryItemsTableOrderingComposer,
    $$PantryItemsTableAnnotationComposer,
    $$PantryItemsTableCreateCompanionBuilder,
    $$PantryItemsTableUpdateCompanionBuilder,
    (PantryItem, BaseReferences<_$AppDatabase, $PantryItemsTable, PantryItem>),
    PantryItem,
    PrefetchHooks Function()>;
typedef $$ContactsTableCreateCompanionBuilder = ContactsCompanion Function({
  required String id,
  required String name,
  Value<String?> notes,
  Value<String?> photoPath,
  Value<DateTime?> birthday,
  Value<DateTime?> lastContactedAt,
  Value<int?> reminderIntervalDays,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ContactsTableUpdateCompanionBuilder = ContactsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> notes,
  Value<String?> photoPath,
  Value<DateTime?> birthday,
  Value<DateTime?> lastContactedAt,
  Value<int?> reminderIntervalDays,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ContactsTableFilterComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get birthday => $composableBuilder(
      column: $table.birthday, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastContactedAt => $composableBuilder(
      column: $table.lastContactedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reminderIntervalDays => $composableBuilder(
      column: $table.reminderIntervalDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get birthday => $composableBuilder(
      column: $table.birthday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastContactedAt => $composableBuilder(
      column: $table.lastContactedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reminderIntervalDays => $composableBuilder(
      column: $table.reminderIntervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContactsTable> {
  $$ContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get birthday =>
      $composableBuilder(column: $table.birthday, builder: (column) => column);

  GeneratedColumn<DateTime> get lastContactedAt => $composableBuilder(
      column: $table.lastContactedAt, builder: (column) => column);

  GeneratedColumn<int> get reminderIntervalDays => $composableBuilder(
      column: $table.reminderIntervalDays, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ContactsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContactsTable,
    Contact,
    $$ContactsTableFilterComposer,
    $$ContactsTableOrderingComposer,
    $$ContactsTableAnnotationComposer,
    $$ContactsTableCreateCompanionBuilder,
    $$ContactsTableUpdateCompanionBuilder,
    (Contact, BaseReferences<_$AppDatabase, $ContactsTable, Contact>),
    Contact,
    PrefetchHooks Function()> {
  $$ContactsTableTableManager(_$AppDatabase db, $ContactsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<DateTime?> birthday = const Value.absent(),
            Value<DateTime?> lastContactedAt = const Value.absent(),
            Value<int?> reminderIntervalDays = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContactsCompanion(
            id: id,
            name: name,
            notes: notes,
            photoPath: photoPath,
            birthday: birthday,
            lastContactedAt: lastContactedAt,
            reminderIntervalDays: reminderIntervalDays,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<DateTime?> birthday = const Value.absent(),
            Value<DateTime?> lastContactedAt = const Value.absent(),
            Value<int?> reminderIntervalDays = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContactsCompanion.insert(
            id: id,
            name: name,
            notes: notes,
            photoPath: photoPath,
            birthday: birthday,
            lastContactedAt: lastContactedAt,
            reminderIntervalDays: reminderIntervalDays,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ContactsTable, Contact>(table),
                    BaseReferences<_$AppDatabase, $ContactsTable, Contact>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ContactsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContactsTable,
    Contact,
    $$ContactsTableFilterComposer,
    $$ContactsTableOrderingComposer,
    $$ContactsTableAnnotationComposer,
    $$ContactsTableCreateCompanionBuilder,
    $$ContactsTableUpdateCompanionBuilder,
    (Contact, BaseReferences<_$AppDatabase, $ContactsTable, Contact>),
    Contact,
    PrefetchHooks Function()>;
typedef $$EnvelopesTableCreateCompanionBuilder = EnvelopesCompanion Function({
  required String id,
  required String name,
  Value<String?> icon,
  Value<int> balanceCents,
  Value<int?> targetCents,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$EnvelopesTableUpdateCompanionBuilder = EnvelopesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> icon,
  Value<int> balanceCents,
  Value<int?> targetCents,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$EnvelopesTableReferences
    extends BaseReferences<_$AppDatabase, $EnvelopesTable, Envelope> {
  $$EnvelopesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EnvelopeTransactionsTable,
      List<EnvelopeTransaction>> _envelopeTransactionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.envelopeTransactions,
          aliasName: 'envelopes__id__envelope_transactions__envelope_id');

  $$EnvelopeTransactionsTableProcessedTableManager
      get envelopeTransactionsRefs {
    final manager = $$EnvelopeTransactionsTableTableManager(
            $_db, $_db.envelopeTransactions)
        .filter((f) => f.envelopeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_envelopeTransactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EnvelopesTableFilterComposer
    extends Composer<_$AppDatabase, $EnvelopesTable> {
  $$EnvelopesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get balanceCents => $composableBuilder(
      column: $table.balanceCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetCents => $composableBuilder(
      column: $table.targetCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> envelopeTransactionsRefs(
      Expression<bool> Function($$EnvelopeTransactionsTableFilterComposer f)
          f) {
    final $$EnvelopeTransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.envelopeTransactions,
        getReferencedColumn: (t) => t.envelopeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EnvelopeTransactionsTableFilterComposer(
              $db: $db,
              $table: $db.envelopeTransactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EnvelopesTableOrderingComposer
    extends Composer<_$AppDatabase, $EnvelopesTable> {
  $$EnvelopesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get balanceCents => $composableBuilder(
      column: $table.balanceCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetCents => $composableBuilder(
      column: $table.targetCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$EnvelopesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnvelopesTable> {
  $$EnvelopesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get balanceCents => $composableBuilder(
      column: $table.balanceCents, builder: (column) => column);

  GeneratedColumn<int> get targetCents => $composableBuilder(
      column: $table.targetCents, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> envelopeTransactionsRefs<T extends Object>(
      Expression<T> Function($$EnvelopeTransactionsTableAnnotationComposer a)
          f) {
    final $$EnvelopeTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.envelopeTransactions,
            getReferencedColumn: (t) => t.envelopeId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EnvelopeTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.envelopeTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$EnvelopesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EnvelopesTable,
    Envelope,
    $$EnvelopesTableFilterComposer,
    $$EnvelopesTableOrderingComposer,
    $$EnvelopesTableAnnotationComposer,
    $$EnvelopesTableCreateCompanionBuilder,
    $$EnvelopesTableUpdateCompanionBuilder,
    (Envelope, $$EnvelopesTableReferences),
    Envelope,
    PrefetchHooks Function({bool envelopeTransactionsRefs})> {
  $$EnvelopesTableTableManager(_$AppDatabase db, $EnvelopesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnvelopesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnvelopesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnvelopesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<int> balanceCents = const Value.absent(),
            Value<int?> targetCents = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EnvelopesCompanion(
            id: id,
            name: name,
            icon: icon,
            balanceCents: balanceCents,
            targetCents: targetCents,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> icon = const Value.absent(),
            Value<int> balanceCents = const Value.absent(),
            Value<int?> targetCents = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EnvelopesCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            balanceCents: balanceCents,
            targetCents: targetCents,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$EnvelopesTable, Envelope>(table),
                    $$EnvelopesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({envelopeTransactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (envelopeTransactionsRefs) db.envelopeTransactions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (envelopeTransactionsRefs)
                    await $_getPrefetchedData<Envelope, $EnvelopesTable,
                            EnvelopeTransaction>(
                        currentTable: table,
                        referencedTable: $$EnvelopesTableReferences
                            ._envelopeTransactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EnvelopesTableReferences(db, table, p0)
                                .envelopeTransactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.envelopeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EnvelopesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EnvelopesTable,
    Envelope,
    $$EnvelopesTableFilterComposer,
    $$EnvelopesTableOrderingComposer,
    $$EnvelopesTableAnnotationComposer,
    $$EnvelopesTableCreateCompanionBuilder,
    $$EnvelopesTableUpdateCompanionBuilder,
    (Envelope, $$EnvelopesTableReferences),
    Envelope,
    PrefetchHooks Function({bool envelopeTransactionsRefs})>;
typedef $$EnvelopeTransactionsTableCreateCompanionBuilder
    = EnvelopeTransactionsCompanion Function({
  required String id,
  required String envelopeId,
  required int amountCents,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$EnvelopeTransactionsTableUpdateCompanionBuilder
    = EnvelopeTransactionsCompanion Function({
  Value<String> id,
  Value<String> envelopeId,
  Value<int> amountCents,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$EnvelopeTransactionsTableReferences extends BaseReferences<
    _$AppDatabase, $EnvelopeTransactionsTable, EnvelopeTransaction> {
  $$EnvelopeTransactionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EnvelopesTable _envelopeIdTable(_$AppDatabase db) => db.envelopes
      .createAlias('envelope_transactions__envelope_id__envelopes__id');

  $$EnvelopesTableProcessedTableManager get envelopeId {
    final $_column = $_itemColumn<String>('envelope_id')!;

    final manager = $$EnvelopesTableTableManager($_db, $_db.envelopes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_envelopeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EnvelopeTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $EnvelopeTransactionsTable> {
  $$EnvelopeTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$EnvelopesTableFilterComposer get envelopeId {
    final $$EnvelopesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.envelopeId,
        referencedTable: $db.envelopes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EnvelopesTableFilterComposer(
              $db: $db,
              $table: $db.envelopes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EnvelopeTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $EnvelopeTransactionsTable> {
  $$EnvelopeTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$EnvelopesTableOrderingComposer get envelopeId {
    final $$EnvelopesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.envelopeId,
        referencedTable: $db.envelopes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EnvelopesTableOrderingComposer(
              $db: $db,
              $table: $db.envelopes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EnvelopeTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnvelopeTransactionsTable> {
  $$EnvelopeTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EnvelopesTableAnnotationComposer get envelopeId {
    final $$EnvelopesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.envelopeId,
        referencedTable: $db.envelopes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EnvelopesTableAnnotationComposer(
              $db: $db,
              $table: $db.envelopes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EnvelopeTransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EnvelopeTransactionsTable,
    EnvelopeTransaction,
    $$EnvelopeTransactionsTableFilterComposer,
    $$EnvelopeTransactionsTableOrderingComposer,
    $$EnvelopeTransactionsTableAnnotationComposer,
    $$EnvelopeTransactionsTableCreateCompanionBuilder,
    $$EnvelopeTransactionsTableUpdateCompanionBuilder,
    (EnvelopeTransaction, $$EnvelopeTransactionsTableReferences),
    EnvelopeTransaction,
    PrefetchHooks Function({bool envelopeId})> {
  $$EnvelopeTransactionsTableTableManager(
      _$AppDatabase db, $EnvelopeTransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnvelopeTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnvelopeTransactionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnvelopeTransactionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> envelopeId = const Value.absent(),
            Value<int> amountCents = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EnvelopeTransactionsCompanion(
            id: id,
            envelopeId: envelopeId,
            amountCents: amountCents,
            note: note,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String envelopeId,
            required int amountCents,
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EnvelopeTransactionsCompanion.insert(
            id: id,
            envelopeId: envelopeId,
            amountCents: amountCents,
            note: note,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$EnvelopeTransactionsTable,
                        EnvelopeTransaction>(table),
                    $$EnvelopeTransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({envelopeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (envelopeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.envelopeId,
                    referencedTable: $$EnvelopeTransactionsTableReferences
                        ._envelopeIdTable(db),
                    referencedColumn: $$EnvelopeTransactionsTableReferences
                        ._envelopeIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EnvelopeTransactionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $EnvelopeTransactionsTable,
        EnvelopeTransaction,
        $$EnvelopeTransactionsTableFilterComposer,
        $$EnvelopeTransactionsTableOrderingComposer,
        $$EnvelopeTransactionsTableAnnotationComposer,
        $$EnvelopeTransactionsTableCreateCompanionBuilder,
        $$EnvelopeTransactionsTableUpdateCompanionBuilder,
        (EnvelopeTransaction, $$EnvelopeTransactionsTableReferences),
        EnvelopeTransaction,
        PrefetchHooks Function({bool envelopeId})>;
typedef $$HealthAppointmentsTableCreateCompanionBuilder
    = HealthAppointmentsCompanion Function({
  required String id,
  required String name,
  required int intervalDays,
  Value<DateTime?> lastCompletedAt,
  Value<String?> notes,
  Value<String?> institution,
  Value<String?> address,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$HealthAppointmentsTableUpdateCompanionBuilder
    = HealthAppointmentsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> intervalDays,
  Value<DateTime?> lastCompletedAt,
  Value<String?> notes,
  Value<String?> institution,
  Value<String?> address,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$HealthAppointmentsTableFilterComposer
    extends Composer<_$AppDatabase, $HealthAppointmentsTable> {
  $$HealthAppointmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastCompletedAt => $composableBuilder(
      column: $table.lastCompletedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$HealthAppointmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthAppointmentsTable> {
  $$HealthAppointmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastCompletedAt => $composableBuilder(
      column: $table.lastCompletedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$HealthAppointmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthAppointmentsTable> {
  $$HealthAppointmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCompletedAt => $composableBuilder(
      column: $table.lastCompletedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get institution => $composableBuilder(
      column: $table.institution, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HealthAppointmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HealthAppointmentsTable,
    HealthAppointment,
    $$HealthAppointmentsTableFilterComposer,
    $$HealthAppointmentsTableOrderingComposer,
    $$HealthAppointmentsTableAnnotationComposer,
    $$HealthAppointmentsTableCreateCompanionBuilder,
    $$HealthAppointmentsTableUpdateCompanionBuilder,
    (
      HealthAppointment,
      BaseReferences<_$AppDatabase, $HealthAppointmentsTable, HealthAppointment>
    ),
    HealthAppointment,
    PrefetchHooks Function()> {
  $$HealthAppointmentsTableTableManager(
      _$AppDatabase db, $HealthAppointmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthAppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthAppointmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthAppointmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<DateTime?> lastCompletedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> institution = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HealthAppointmentsCompanion(
            id: id,
            name: name,
            intervalDays: intervalDays,
            lastCompletedAt: lastCompletedAt,
            notes: notes,
            institution: institution,
            address: address,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int intervalDays,
            Value<DateTime?> lastCompletedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> institution = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HealthAppointmentsCompanion.insert(
            id: id,
            name: name,
            intervalDays: intervalDays,
            lastCompletedAt: lastCompletedAt,
            notes: notes,
            institution: institution,
            address: address,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$HealthAppointmentsTable, HealthAppointment>(
                        table),
                    BaseReferences<_$AppDatabase, $HealthAppointmentsTable,
                        HealthAppointment>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HealthAppointmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HealthAppointmentsTable,
    HealthAppointment,
    $$HealthAppointmentsTableFilterComposer,
    $$HealthAppointmentsTableOrderingComposer,
    $$HealthAppointmentsTableAnnotationComposer,
    $$HealthAppointmentsTableCreateCompanionBuilder,
    $$HealthAppointmentsTableUpdateCompanionBuilder,
    (
      HealthAppointment,
      BaseReferences<_$AppDatabase, $HealthAppointmentsTable, HealthAppointment>
    ),
    HealthAppointment,
    PrefetchHooks Function()>;
typedef $$MedicationsTableCreateCompanionBuilder = MedicationsCompanion
    Function({
  required String id,
  required String name,
  Value<String?> dosageNote,
  Value<int> timesPerDay,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$MedicationsTableUpdateCompanionBuilder = MedicationsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> dosageNote,
  Value<int> timesPerDay,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$MedicationsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicationsTable, Medication> {
  $$MedicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicationIntakeLogsTable,
      List<MedicationIntakeLog>> _medicationIntakeLogsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.medicationIntakeLogs,
          aliasName: 'medications__id__medication_intake_logs__medication_id');

  $$MedicationIntakeLogsTableProcessedTableManager
      get medicationIntakeLogsRefs {
    final manager = $$MedicationIntakeLogsTableTableManager(
            $_db, $_db.medicationIntakeLogs)
        .filter(
            (f) => f.medicationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_medicationIntakeLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dosageNote => $composableBuilder(
      column: $table.dosageNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timesPerDay => $composableBuilder(
      column: $table.timesPerDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> medicationIntakeLogsRefs(
      Expression<bool> Function($$MedicationIntakeLogsTableFilterComposer f)
          f) {
    final $$MedicationIntakeLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.medicationIntakeLogs,
        getReferencedColumn: (t) => t.medicationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationIntakeLogsTableFilterComposer(
              $db: $db,
              $table: $db.medicationIntakeLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dosageNote => $composableBuilder(
      column: $table.dosageNote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timesPerDay => $composableBuilder(
      column: $table.timesPerDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dosageNote => $composableBuilder(
      column: $table.dosageNote, builder: (column) => column);

  GeneratedColumn<int> get timesPerDay => $composableBuilder(
      column: $table.timesPerDay, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> medicationIntakeLogsRefs<T extends Object>(
      Expression<T> Function($$MedicationIntakeLogsTableAnnotationComposer a)
          f) {
    final $$MedicationIntakeLogsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.medicationIntakeLogs,
            getReferencedColumn: (t) => t.medicationId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MedicationIntakeLogsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.medicationIntakeLogs,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$MedicationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicationsTable,
    Medication,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (Medication, $$MedicationsTableReferences),
    Medication,
    PrefetchHooks Function({bool medicationIntakeLogsRefs})> {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> dosageNote = const Value.absent(),
            Value<int> timesPerDay = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationsCompanion(
            id: id,
            name: name,
            dosageNote: dosageNote,
            timesPerDay: timesPerDay,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> dosageNote = const Value.absent(),
            Value<int> timesPerDay = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationsCompanion.insert(
            id: id,
            name: name,
            dosageNote: dosageNote,
            timesPerDay: timesPerDay,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MedicationsTable, Medication>(table),
                    $$MedicationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({medicationIntakeLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (medicationIntakeLogsRefs) db.medicationIntakeLogs
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicationIntakeLogsRefs)
                    await $_getPrefetchedData<Medication, $MedicationsTable,
                            MedicationIntakeLog>(
                        currentTable: table,
                        referencedTable: $$MedicationsTableReferences
                            ._medicationIntakeLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MedicationsTableReferences(db, table, p0)
                                .medicationIntakeLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.medicationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MedicationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicationsTable,
    Medication,
    $$MedicationsTableFilterComposer,
    $$MedicationsTableOrderingComposer,
    $$MedicationsTableAnnotationComposer,
    $$MedicationsTableCreateCompanionBuilder,
    $$MedicationsTableUpdateCompanionBuilder,
    (Medication, $$MedicationsTableReferences),
    Medication,
    PrefetchHooks Function({bool medicationIntakeLogsRefs})>;
typedef $$MedicationIntakeLogsTableCreateCompanionBuilder
    = MedicationIntakeLogsCompanion Function({
  required String id,
  required String medicationId,
  required DateTime date,
  Value<int> takenCount,
  Value<int> rowid,
});
typedef $$MedicationIntakeLogsTableUpdateCompanionBuilder
    = MedicationIntakeLogsCompanion Function({
  Value<String> id,
  Value<String> medicationId,
  Value<DateTime> date,
  Value<int> takenCount,
  Value<int> rowid,
});

final class $$MedicationIntakeLogsTableReferences extends BaseReferences<
    _$AppDatabase, $MedicationIntakeLogsTable, MedicationIntakeLog> {
  $$MedicationIntakeLogsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MedicationsTable _medicationIdTable(_$AppDatabase db) => db
      .medications
      .createAlias('medication_intake_logs__medication_id__medications__id');

  $$MedicationsTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<String>('medication_id')!;

    final manager = $$MedicationsTableTableManager($_db, $_db.medications)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MedicationIntakeLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationIntakeLogsTable> {
  $$MedicationIntakeLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get takenCount => $composableBuilder(
      column: $table.takenCount, builder: (column) => ColumnFilters(column));

  $$MedicationsTableFilterComposer get medicationId {
    final $$MedicationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableFilterComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MedicationIntakeLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationIntakeLogsTable> {
  $$MedicationIntakeLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get takenCount => $composableBuilder(
      column: $table.takenCount, builder: (column) => ColumnOrderings(column));

  $$MedicationsTableOrderingComposer get medicationId {
    final $$MedicationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableOrderingComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MedicationIntakeLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationIntakeLogsTable> {
  $$MedicationIntakeLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get takenCount => $composableBuilder(
      column: $table.takenCount, builder: (column) => column);

  $$MedicationsTableAnnotationComposer get medicationId {
    final $$MedicationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.medicationId,
        referencedTable: $db.medications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MedicationsTableAnnotationComposer(
              $db: $db,
              $table: $db.medications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MedicationIntakeLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicationIntakeLogsTable,
    MedicationIntakeLog,
    $$MedicationIntakeLogsTableFilterComposer,
    $$MedicationIntakeLogsTableOrderingComposer,
    $$MedicationIntakeLogsTableAnnotationComposer,
    $$MedicationIntakeLogsTableCreateCompanionBuilder,
    $$MedicationIntakeLogsTableUpdateCompanionBuilder,
    (MedicationIntakeLog, $$MedicationIntakeLogsTableReferences),
    MedicationIntakeLog,
    PrefetchHooks Function({bool medicationId})> {
  $$MedicationIntakeLogsTableTableManager(
      _$AppDatabase db, $MedicationIntakeLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationIntakeLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationIntakeLogsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationIntakeLogsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> medicationId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> takenCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationIntakeLogsCompanion(
            id: id,
            medicationId: medicationId,
            date: date,
            takenCount: takenCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String medicationId,
            required DateTime date,
            Value<int> takenCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicationIntakeLogsCompanion.insert(
            id: id,
            medicationId: medicationId,
            date: date,
            takenCount: takenCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MedicationIntakeLogsTable,
                        MedicationIntakeLog>(table),
                    $$MedicationIntakeLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (medicationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.medicationId,
                    referencedTable: $$MedicationIntakeLogsTableReferences
                        ._medicationIdTable(db),
                    referencedColumn: $$MedicationIntakeLogsTableReferences
                        ._medicationIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MedicationIntakeLogsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MedicationIntakeLogsTable,
        MedicationIntakeLog,
        $$MedicationIntakeLogsTableFilterComposer,
        $$MedicationIntakeLogsTableOrderingComposer,
        $$MedicationIntakeLogsTableAnnotationComposer,
        $$MedicationIntakeLogsTableCreateCompanionBuilder,
        $$MedicationIntakeLogsTableUpdateCompanionBuilder,
        (MedicationIntakeLog, $$MedicationIntakeLogsTableReferences),
        MedicationIntakeLog,
        PrefetchHooks Function({bool medicationId})>;
typedef $$StorageLocationsTableCreateCompanionBuilder
    = StorageLocationsCompanion Function({
  required String id,
  required String itemName,
  required String location,
  Value<String?> notes,
  Value<String?> photoPath,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$StorageLocationsTableUpdateCompanionBuilder
    = StorageLocationsCompanion Function({
  Value<String> id,
  Value<String> itemName,
  Value<String> location,
  Value<String?> notes,
  Value<String?> photoPath,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$StorageLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $StorageLocationsTable> {
  $$StorageLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$StorageLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $StorageLocationsTable> {
  $$StorageLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$StorageLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StorageLocationsTable> {
  $$StorageLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StorageLocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StorageLocationsTable,
    StorageLocation,
    $$StorageLocationsTableFilterComposer,
    $$StorageLocationsTableOrderingComposer,
    $$StorageLocationsTableAnnotationComposer,
    $$StorageLocationsTableCreateCompanionBuilder,
    $$StorageLocationsTableUpdateCompanionBuilder,
    (
      StorageLocation,
      BaseReferences<_$AppDatabase, $StorageLocationsTable, StorageLocation>
    ),
    StorageLocation,
    PrefetchHooks Function()> {
  $$StorageLocationsTableTableManager(
      _$AppDatabase db, $StorageLocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StorageLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StorageLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StorageLocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> itemName = const Value.absent(),
            Value<String> location = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StorageLocationsCompanion(
            id: id,
            itemName: itemName,
            location: location,
            notes: notes,
            photoPath: photoPath,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String itemName,
            required String location,
            Value<String?> notes = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StorageLocationsCompanion.insert(
            id: id,
            itemName: itemName,
            location: location,
            notes: notes,
            photoPath: photoPath,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$StorageLocationsTable, StorageLocation>(table),
                    BaseReferences<_$AppDatabase, $StorageLocationsTable,
                        StorageLocation>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StorageLocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StorageLocationsTable,
    StorageLocation,
    $$StorageLocationsTableFilterComposer,
    $$StorageLocationsTableOrderingComposer,
    $$StorageLocationsTableAnnotationComposer,
    $$StorageLocationsTableCreateCompanionBuilder,
    $$StorageLocationsTableUpdateCompanionBuilder,
    (
      StorageLocation,
      BaseReferences<_$AppDatabase, $StorageLocationsTable, StorageLocation>
    ),
    StorageLocation,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HouseholdTasksTableTableManager get householdTasks =>
      $$HouseholdTasksTableTableManager(_db, _db.householdTasks);
  $$TaskCompletionLogsTableTableManager get taskCompletionLogs =>
      $$TaskCompletionLogsTableTableManager(_db, _db.taskCompletionLogs);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$RoutineItemsTableTableManager get routineItems =>
      $$RoutineItemsTableTableManager(_db, _db.routineItems);
  $$RoutineCompletionsTableTableManager get routineCompletions =>
      $$RoutineCompletionsTableTableManager(_db, _db.routineCompletions);
  $$BrainDumpEntriesTableTableManager get brainDumpEntries =>
      $$BrainDumpEntriesTableTableManager(_db, _db.brainDumpEntries);
  $$PantryItemsTableTableManager get pantryItems =>
      $$PantryItemsTableTableManager(_db, _db.pantryItems);
  $$ContactsTableTableManager get contacts =>
      $$ContactsTableTableManager(_db, _db.contacts);
  $$EnvelopesTableTableManager get envelopes =>
      $$EnvelopesTableTableManager(_db, _db.envelopes);
  $$EnvelopeTransactionsTableTableManager get envelopeTransactions =>
      $$EnvelopeTransactionsTableTableManager(_db, _db.envelopeTransactions);
  $$HealthAppointmentsTableTableManager get healthAppointments =>
      $$HealthAppointmentsTableTableManager(_db, _db.healthAppointments);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$MedicationIntakeLogsTableTableManager get medicationIntakeLogs =>
      $$MedicationIntakeLogsTableTableManager(_db, _db.medicationIntakeLogs);
  $$StorageLocationsTableTableManager get storageLocations =>
      $$StorageLocationsTableTableManager(_db, _db.storageLocations);
}
