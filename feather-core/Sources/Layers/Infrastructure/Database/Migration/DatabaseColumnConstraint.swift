public enum DatabaseColumnConstraint: Sendable {
    case primaryKey
    case notNull
    case unique
    case defaultValue(DatabaseColumnDefault)
}
