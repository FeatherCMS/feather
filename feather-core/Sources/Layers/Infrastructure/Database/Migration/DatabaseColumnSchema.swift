public struct DatabaseColumnSchema: Sendable {
    public let name: String
    public let type: DatabaseColumnType
    public let constraints: [DatabaseColumnConstraint]

    public init<Value>(
        field: DatabaseField<Value>,
        type: DatabaseColumnType,
        constraints: [DatabaseColumnConstraint] = []
    ) {
        self.name = field.name
        self.type = type
        self.constraints = constraints
    }
}
