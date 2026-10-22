public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol MetadataOperation: BearerProtectedOperation {
}

extension MetadataOperation {
    public var tags: [any TagRepresentable] { [MetadataTag()] }
}
