public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct WebMetadataGetPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { WebMetadataGetOperation() }

    public init() {}
}
