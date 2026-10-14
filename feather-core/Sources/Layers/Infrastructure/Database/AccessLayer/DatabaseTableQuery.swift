import FeatherDatabase

public struct DatabaseTableQuery {

    public enum SortDirection {
        case ascending
        case descending
    }

    public struct Ordering {
        public let field: any DatabaseFieldRepresentable
        public let direction: SortDirection

        public init(
            field: any DatabaseFieldRepresentable,
            direction: SortDirection
        ) {
            self.field = field
            self.direction = direction
        }
    }

    private var conditions: [String] = []
    private var bindings: [DatabaseQueryBindings] = []
    private var ordering: [String] = []
    private var rowLimit: Int?
    private var rowOffset: Int?

    public init() {}

    public func filter<Value: DatabaseFieldValue>(
        _ field: DatabaseField<Value>,
        equals value: Value
    ) -> Self {
        var query = self
        guard let binding = value.databaseQueryBinding else {
            query.conditions.append("\(field.name) IS NULL")
            return query
        }
        let placeholder = query.append(binding)
        query.conditions.append("\(field.name) = \(placeholder)")
        return query
    }

    public func filter<Value: DatabaseFieldValue>(
        _ field: DatabaseField<Value>,
        isIn values: [Value]
    ) -> Self {
        var query = self
        var placeholders: [String] = []
        var includesNull = false

        for value in values {
            guard let binding = value.databaseQueryBinding else {
                includesNull = true
                continue
            }
            placeholders.append(query.append(binding))
        }

        var alternatives: [String] = []
        if !placeholders.isEmpty {
            alternatives.append(
                "\(field.name) IN (\(placeholders.joined(separator: ", ")))"
            )
        }
        if includesNull {
            alternatives.append("\(field.name) IS NULL")
        }
        let condition = alternatives.isEmpty
            ? "FALSE"
            : "(\(alternatives.joined(separator: " OR ")))"
        query.conditions.append(condition)
        return query
    }

    public func search(
        _ value: String,
        in fields: [any DatabaseFieldRepresentable]
    ) -> Self {
        var query = self
        let alternatives = fields.map { field in
            let placeholder = query.append(.string("%\(value.lowercased())%"))
            return "LOWER(\(field.name)) LIKE \(placeholder)"
        }
        if !alternatives.isEmpty {
            query.conditions.append("(\(alternatives.joined(separator: " OR ")))")
        }
        return query
    }

    public func orderBy(
        _ field: any DatabaseFieldRepresentable,
        _ direction: SortDirection
    ) -> Self {
        orderBy([Ordering(field: field, direction: direction)])
    }

    public func orderBy(_ orderings: [Ordering]) -> Self {
        var query = self
        for ordering in orderings {
            let sqlDirection = switch ordering.direction {
            case .ascending:
                "ASC"
            case .descending:
                "DESC"
            }
            query.ordering.append("\(ordering.field.name) \(sqlDirection)")
        }
        return query
    }

    public func limit(_ value: Int) -> Self {
        var query = self
        query.rowLimit = max(0, value)
        return query
    }

    public func offset(_ value: Int) -> Self {
        var query = self
        query.rowOffset = max(0, value)
        return query
    }

    var whereSQL: String {
        conditions.joined(separator: " AND ")
    }

    var queryBindings: [DatabaseQueryBindings] {
        bindings
    }

    var orderBySQL: String {
        ordering.joined(separator: ", ")
    }

    var limitSQL: String? {
        rowLimit.map { String($0) }
    }

    var offsetSQL: String? {
        rowOffset.map { String($0) }
    }

    private mutating func append(
        _ binding: DatabaseQueryBinding
    ) -> String {
        bindings.append(
            DatabaseQueryBindings(
                index: bindings.count,
                binding: binding
            )
        )
        return "{{\(bindings.count)}}"
    }
}
