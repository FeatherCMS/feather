public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol WebMetadataOperation: BearerProtectedOperation {
}

extension WebMetadataOperation {
    public var tags: [any TagRepresentable] { [WebMetadataTag()] }
}
