public struct DatabaseField<Value: Decodable & Sendable>:
    DatabaseFieldRepresentable,
    Sendable
{

    public let name: String

    public init(_ name: String) {
        self.name = name
    }
}
