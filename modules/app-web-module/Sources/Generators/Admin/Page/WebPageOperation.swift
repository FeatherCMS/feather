public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol WebPageOperation: BearerProtectedOperation {
}

extension WebPageOperation {
    public var tags: [any TagRepresentable] { [WebPageTag()] }
}
