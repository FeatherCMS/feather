import FeatherOpenAPI

public struct BlogTagListPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { BlogTagListOperation() }

    public init() {}
}

public struct BlogTagGetPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { BlogTagGetOperation() }

    public init() {}
}
