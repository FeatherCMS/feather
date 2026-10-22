import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

public protocol WebMenuItemOperation: BearerProtectedOperation {
}

extension WebMenuItemOperation {
    public var tags: [any TagRepresentable] { [WebMenuItemTag()] }
}
