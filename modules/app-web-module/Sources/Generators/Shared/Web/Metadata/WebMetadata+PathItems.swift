import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct WebMetadataGetPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { WebMetadataGetOperation() }

    public init() {}
}
