public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol PageOperation: BearerProtectedOperation {
}

extension PageOperation {
    public var tags: [any TagRepresentable] { [PageTag()] }
}
