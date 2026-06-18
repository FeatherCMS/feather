import FeatherOpenAPI

public struct WebMenuListPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { WebMenuListOperation() }

    public init() {}
}
