public struct DatabaseTableSchema: Sendable {
    public let name: String
    public let columns: [DatabaseColumnSchema]
    public let constraints: [DatabaseTableConstraint]
    public let indexes: [DatabaseIndexSchema]

    public init(
        name: String,
        columns: [DatabaseColumnSchema],
        constraints: [DatabaseTableConstraint] = [],
        indexes: [DatabaseIndexSchema] = []
    ) {
        self.name = name
        self.columns = columns
        self.constraints = constraints
        self.indexes = indexes
    }
}
