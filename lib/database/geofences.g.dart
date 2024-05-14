// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofences.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGeofencesCollection on Isar {
  IsarCollection<Geofences> get geofences => this.collection();
}

const GeofencesSchema = CollectionSchema(
  name: r'Geofences',
  id: -4599795393593204107,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'color': PropertySchema(
      id: 1,
      name: r'color',
      type: IsarType.long,
    ),
    r'dailyTimeSpentInSeconds': PropertySchema(
      id: 2,
      name: r'dailyTimeSpentInSeconds',
      type: IsarType.long,
    ),
    r'entryTimestamp': PropertySchema(
      id: 3,
      name: r'entryTimestamp',
      type: IsarType.dateTime,
    ),
    r'exitTimestamp': PropertySchema(
      id: 4,
      name: r'exitTimestamp',
      type: IsarType.dateTime,
    ),
    r'latitude': PropertySchema(
      id: 5,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 6,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'name': PropertySchema(
      id: 7,
      name: r'name',
      type: IsarType.string,
    ),
    r'radius': PropertySchema(
      id: 8,
      name: r'radius',
      type: IsarType.double,
    ),
    r'sessionTimeSpentInSeconds': PropertySchema(
      id: 9,
      name: r'sessionTimeSpentInSeconds',
      type: IsarType.long,
    ),
    r'totalTimeSpentInSeconds': PropertySchema(
      id: 10,
      name: r'totalTimeSpentInSeconds',
      type: IsarType.long,
    )
  },
  estimateSize: _geofencesEstimateSize,
  serialize: _geofencesSerialize,
  deserialize: _geofencesDeserialize,
  deserializeProp: _geofencesDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _geofencesGetId,
  getLinks: _geofencesGetLinks,
  attach: _geofencesAttach,
  version: '3.1.0+1',
);

int _geofencesEstimateSize(
  Geofences object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.category;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _geofencesSerialize(
  Geofences object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeLong(offsets[1], object.color);
  writer.writeLong(offsets[2], object.dailyTimeSpentInSeconds);
  writer.writeDateTime(offsets[3], object.entryTimestamp);
  writer.writeDateTime(offsets[4], object.exitTimestamp);
  writer.writeDouble(offsets[5], object.latitude);
  writer.writeDouble(offsets[6], object.longitude);
  writer.writeString(offsets[7], object.name);
  writer.writeDouble(offsets[8], object.radius);
  writer.writeLong(offsets[9], object.sessionTimeSpentInSeconds);
  writer.writeLong(offsets[10], object.totalTimeSpentInSeconds);
}

Geofences _geofencesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Geofences(
    category: reader.readStringOrNull(offsets[0]),
    color: reader.readLong(offsets[1]),
    dailyTimeSpentInSeconds: reader.readLong(offsets[2]),
    entryTimestamp: reader.readDateTimeOrNull(offsets[3]),
    exitTimestamp: reader.readDateTimeOrNull(offsets[4]),
    latitude: reader.readDouble(offsets[5]),
    longitude: reader.readDouble(offsets[6]),
    name: reader.readString(offsets[7]),
    radius: reader.readDoubleOrNull(offsets[8]),
  );
  object.id = id;
  object.sessionTimeSpentInSeconds = reader.readLong(offsets[9]);
  object.totalTimeSpentInSeconds = reader.readLong(offsets[10]);
  return object;
}

P _geofencesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _geofencesGetId(Geofences object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _geofencesGetLinks(Geofences object) {
  return [];
}

void _geofencesAttach(IsarCollection<dynamic> col, Id id, Geofences object) {
  object.id = id;
}

extension GeofencesQueryWhereSort
    on QueryBuilder<Geofences, Geofences, QWhere> {
  QueryBuilder<Geofences, Geofences, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GeofencesQueryWhere
    on QueryBuilder<Geofences, Geofences, QWhereClause> {
  QueryBuilder<Geofences, Geofences, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GeofencesQueryFilter
    on QueryBuilder<Geofences, Geofences, QFilterCondition> {
  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      categoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> categoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> categoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> categoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> categoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> categoryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> categoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> colorEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> colorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> colorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> colorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      dailyTimeSpentInSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyTimeSpentInSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      dailyTimeSpentInSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyTimeSpentInSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      dailyTimeSpentInSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyTimeSpentInSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      dailyTimeSpentInSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyTimeSpentInSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      entryTimestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'entryTimestamp',
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      entryTimestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'entryTimestamp',
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      entryTimestampEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entryTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      entryTimestampGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entryTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      entryTimestampLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entryTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      entryTimestampBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entryTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      exitTimestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exitTimestamp',
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      exitTimestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exitTimestamp',
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      exitTimestampEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exitTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      exitTimestampGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exitTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      exitTimestampLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exitTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      exitTimestampBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exitTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> latitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> latitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> latitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> latitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> longitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      longitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> longitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> longitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> radiusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'radius',
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> radiusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'radius',
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> radiusEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'radius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> radiusGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'radius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> radiusLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'radius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition> radiusBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'radius',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      sessionTimeSpentInSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionTimeSpentInSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      sessionTimeSpentInSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionTimeSpentInSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      sessionTimeSpentInSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionTimeSpentInSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      sessionTimeSpentInSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionTimeSpentInSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      totalTimeSpentInSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalTimeSpentInSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      totalTimeSpentInSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalTimeSpentInSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      totalTimeSpentInSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalTimeSpentInSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterFilterCondition>
      totalTimeSpentInSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalTimeSpentInSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GeofencesQueryObject
    on QueryBuilder<Geofences, Geofences, QFilterCondition> {}

extension GeofencesQueryLinks
    on QueryBuilder<Geofences, Geofences, QFilterCondition> {}

extension GeofencesQuerySortBy on QueryBuilder<Geofences, Geofences, QSortBy> {
  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy>
      sortByDailyTimeSpentInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyTimeSpentInSeconds', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy>
      sortByDailyTimeSpentInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyTimeSpentInSeconds', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByEntryTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryTimestamp', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByEntryTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryTimestamp', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByExitTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exitTimestamp', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByExitTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exitTimestamp', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radius', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> sortByRadiusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radius', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy>
      sortBySessionTimeSpentInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionTimeSpentInSeconds', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy>
      sortBySessionTimeSpentInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionTimeSpentInSeconds', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy>
      sortByTotalTimeSpentInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTimeSpentInSeconds', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy>
      sortByTotalTimeSpentInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTimeSpentInSeconds', Sort.desc);
    });
  }
}

extension GeofencesQuerySortThenBy
    on QueryBuilder<Geofences, Geofences, QSortThenBy> {
  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy>
      thenByDailyTimeSpentInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyTimeSpentInSeconds', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy>
      thenByDailyTimeSpentInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyTimeSpentInSeconds', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByEntryTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryTimestamp', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByEntryTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryTimestamp', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByExitTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exitTimestamp', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByExitTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exitTimestamp', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radius', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy> thenByRadiusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radius', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy>
      thenBySessionTimeSpentInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionTimeSpentInSeconds', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy>
      thenBySessionTimeSpentInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionTimeSpentInSeconds', Sort.desc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy>
      thenByTotalTimeSpentInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTimeSpentInSeconds', Sort.asc);
    });
  }

  QueryBuilder<Geofences, Geofences, QAfterSortBy>
      thenByTotalTimeSpentInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTimeSpentInSeconds', Sort.desc);
    });
  }
}

extension GeofencesQueryWhereDistinct
    on QueryBuilder<Geofences, Geofences, QDistinct> {
  QueryBuilder<Geofences, Geofences, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Geofences, Geofences, QDistinct> distinctByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color');
    });
  }

  QueryBuilder<Geofences, Geofences, QDistinct>
      distinctByDailyTimeSpentInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyTimeSpentInSeconds');
    });
  }

  QueryBuilder<Geofences, Geofences, QDistinct> distinctByEntryTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entryTimestamp');
    });
  }

  QueryBuilder<Geofences, Geofences, QDistinct> distinctByExitTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exitTimestamp');
    });
  }

  QueryBuilder<Geofences, Geofences, QDistinct> distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<Geofences, Geofences, QDistinct> distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<Geofences, Geofences, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Geofences, Geofences, QDistinct> distinctByRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'radius');
    });
  }

  QueryBuilder<Geofences, Geofences, QDistinct>
      distinctBySessionTimeSpentInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionTimeSpentInSeconds');
    });
  }

  QueryBuilder<Geofences, Geofences, QDistinct>
      distinctByTotalTimeSpentInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalTimeSpentInSeconds');
    });
  }
}

extension GeofencesQueryProperty
    on QueryBuilder<Geofences, Geofences, QQueryProperty> {
  QueryBuilder<Geofences, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Geofences, String?, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<Geofences, int, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<Geofences, int, QQueryOperations>
      dailyTimeSpentInSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyTimeSpentInSeconds');
    });
  }

  QueryBuilder<Geofences, DateTime?, QQueryOperations>
      entryTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entryTimestamp');
    });
  }

  QueryBuilder<Geofences, DateTime?, QQueryOperations> exitTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exitTimestamp');
    });
  }

  QueryBuilder<Geofences, double, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<Geofences, double, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<Geofences, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Geofences, double?, QQueryOperations> radiusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'radius');
    });
  }

  QueryBuilder<Geofences, int, QQueryOperations>
      sessionTimeSpentInSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionTimeSpentInSeconds');
    });
  }

  QueryBuilder<Geofences, int, QQueryOperations>
      totalTimeSpentInSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalTimeSpentInSeconds');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCategoriesCollection on Isar {
  IsarCollection<Categories> get categories => this.collection();
}

const CategoriesSchema = CollectionSchema(
  name: r'Categories',
  id: 15998039275527680,
  properties: {
    r'name': PropertySchema(
      id: 0,
      name: r'name',
      type: IsarType.string,
    ),
    r'standardRadius': PropertySchema(
      id: 1,
      name: r'standardRadius',
      type: IsarType.double,
    )
  },
  estimateSize: _categoriesEstimateSize,
  serialize: _categoriesSerialize,
  deserialize: _categoriesDeserialize,
  deserializeProp: _categoriesDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _categoriesGetId,
  getLinks: _categoriesGetLinks,
  attach: _categoriesAttach,
  version: '3.1.0+1',
);

int _categoriesEstimateSize(
  Categories object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _categoriesSerialize(
  Categories object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
  writer.writeDouble(offsets[1], object.standardRadius);
}

Categories _categoriesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Categories(
    name: reader.readStringOrNull(offsets[0]),
    standardRadius: reader.readDoubleOrNull(offsets[1]),
  );
  object.id = id;
  return object;
}

P _categoriesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _categoriesGetId(Categories object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _categoriesGetLinks(Categories object) {
  return [];
}

void _categoriesAttach(IsarCollection<dynamic> col, Id id, Categories object) {
  object.id = id;
}

extension CategoriesQueryWhereSort
    on QueryBuilder<Categories, Categories, QWhere> {
  QueryBuilder<Categories, Categories, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CategoriesQueryWhere
    on QueryBuilder<Categories, Categories, QWhereClause> {
  QueryBuilder<Categories, Categories, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Categories, Categories, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Categories, Categories, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Categories, Categories, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CategoriesQueryFilter
    on QueryBuilder<Categories, Categories, QFilterCondition> {
  QueryBuilder<Categories, Categories, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition>
      standardRadiusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'standardRadius',
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition>
      standardRadiusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'standardRadius',
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition>
      standardRadiusEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'standardRadius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition>
      standardRadiusGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'standardRadius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition>
      standardRadiusLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'standardRadius',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Categories, Categories, QAfterFilterCondition>
      standardRadiusBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'standardRadius',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension CategoriesQueryObject
    on QueryBuilder<Categories, Categories, QFilterCondition> {}

extension CategoriesQueryLinks
    on QueryBuilder<Categories, Categories, QFilterCondition> {}

extension CategoriesQuerySortBy
    on QueryBuilder<Categories, Categories, QSortBy> {
  QueryBuilder<Categories, Categories, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Categories, Categories, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Categories, Categories, QAfterSortBy> sortByStandardRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'standardRadius', Sort.asc);
    });
  }

  QueryBuilder<Categories, Categories, QAfterSortBy>
      sortByStandardRadiusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'standardRadius', Sort.desc);
    });
  }
}

extension CategoriesQuerySortThenBy
    on QueryBuilder<Categories, Categories, QSortThenBy> {
  QueryBuilder<Categories, Categories, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Categories, Categories, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Categories, Categories, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Categories, Categories, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Categories, Categories, QAfterSortBy> thenByStandardRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'standardRadius', Sort.asc);
    });
  }

  QueryBuilder<Categories, Categories, QAfterSortBy>
      thenByStandardRadiusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'standardRadius', Sort.desc);
    });
  }
}

extension CategoriesQueryWhereDistinct
    on QueryBuilder<Categories, Categories, QDistinct> {
  QueryBuilder<Categories, Categories, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Categories, Categories, QDistinct> distinctByStandardRadius() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'standardRadius');
    });
  }
}

extension CategoriesQueryProperty
    on QueryBuilder<Categories, Categories, QQueryProperty> {
  QueryBuilder<Categories, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Categories, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Categories, double?, QQueryOperations> standardRadiusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'standardRadius');
    });
  }
}
