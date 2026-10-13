public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct WebPageGetPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { WebPageGetOperation() }

    public init() {}
}
