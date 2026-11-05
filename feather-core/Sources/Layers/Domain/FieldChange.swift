/// Describes whether a non-optional field should remain unchanged or receive a new value.
public enum FieldChange<Value: Sendable>: Sendable {
    case unchanged
    case set(Value)

    public init<Failure: Error>(
        value: Value?,
        shouldApply: Bool,
        onMissing: () -> Failure
    ) throws(Failure) {
        guard shouldApply else {
            self = .unchanged
            return
        }

        guard let value else {
            throw onMissing()
        }

        self = .set(value)
    }

    public func apply(to currentValue: Value) -> Value {
        switch self {
        case .unchanged:
            currentValue
        case .set(let value):
            value
        }
    }
}
