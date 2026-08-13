import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct WebMenuListPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { WebMenuListOperation() }

    public init() {}
}
