public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol WebMenuItemOperation: BearerProtectedOperation {
}

extension WebMenuItemOperation {
    public var tags: [any TagRepresentable] { [WebMenuItemTag()] }
}
