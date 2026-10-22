import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

public protocol WebMetadataOperation: BearerProtectedOperation {
}

extension WebMetadataOperation {
    public var tags: [any TagRepresentable] { [WebMetadataTag()] }
}
