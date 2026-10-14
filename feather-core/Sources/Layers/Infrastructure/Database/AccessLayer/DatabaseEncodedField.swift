import FeatherDatabase

struct DatabaseEncodedField: Sendable {

    let name: String
    let binding: DatabaseQueryBinding?
    let expression: DatabaseSQLExpression?
}
