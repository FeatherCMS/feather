public enum DatabaseSQLExpression: Sendable {
    case currentTimestamp

    var sql: String {
        switch self {
        case .currentTimestamp:
            "NOW()"
        }
    }
}
