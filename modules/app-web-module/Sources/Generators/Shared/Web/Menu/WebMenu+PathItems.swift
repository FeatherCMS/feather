public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct WebMenuListPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { WebMenuListOperation() }

    public init() {}
}
