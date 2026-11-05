/// Describes whether an optional field should remain unchanged, receive a value, or be cleared.
public enum OptionalFieldChange<Value: Sendable>: Sendable {
    case unchanged
    case set(Value)
    case clear

    public init(
        value: Value?,
        shouldApply: Bool
    ) {
        guard shouldApply else {
            self = .unchanged
            return
        }

        self = value.map(Self.set) ?? .clear
    }

    public func apply(to currentValue: Value?) -> Value? {
        switch self {
        case .unchanged:
            currentValue
        case .set(let value):
            value
        case .clear:
            nil
        }
    }
}
