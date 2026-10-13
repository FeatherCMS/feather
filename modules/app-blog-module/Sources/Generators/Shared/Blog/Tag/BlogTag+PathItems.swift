public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct BlogTagListPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { BlogTagListOperation() }

    public init() {}
}

public struct BlogTagGetPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { BlogTagGetOperation() }

    public init() {}
}
