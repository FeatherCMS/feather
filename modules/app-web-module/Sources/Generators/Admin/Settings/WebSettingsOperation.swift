public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol WebSettingsOperation: BearerProtectedOperation {
}

extension WebSettingsOperation {
    public var tags: [any TagRepresentable] { [WebSettingsTag()] }
}
