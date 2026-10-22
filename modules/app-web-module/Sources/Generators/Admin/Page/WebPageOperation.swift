import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

public protocol WebPageOperation: BearerProtectedOperation {
}

extension WebPageOperation {
    public var tags: [any TagRepresentable] { [WebPageTag()] }
}
