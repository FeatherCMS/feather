import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct WebPageGetPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { WebPageGetOperation() }

    public init() {}
}
