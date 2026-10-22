public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol MenuItemOperation: BearerProtectedOperation {
}

extension MenuItemOperation {
    public var tags: [any TagRepresentable] { [MenuItemTag()] }
}
