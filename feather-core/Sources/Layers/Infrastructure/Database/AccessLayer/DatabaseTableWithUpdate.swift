public protocol DatabaseTableWithUpdate: DatabaseTable {
    static var primaryKeyField: DatabaseField<String> { get }
}
