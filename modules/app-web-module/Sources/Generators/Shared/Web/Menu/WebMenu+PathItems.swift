public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct WebMenuListPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { WebMenuListOperation() }

    public init() {}
}

public struct WebMenuGetByKeyPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? {
        WebMenuGetByKeyOperation()
    }

    public init() {}
}
