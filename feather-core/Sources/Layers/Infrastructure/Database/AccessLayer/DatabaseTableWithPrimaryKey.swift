public protocol DatabaseTableWithPrimaryKey: DatabaseTable {
    static var primaryKey: String { get }
}
