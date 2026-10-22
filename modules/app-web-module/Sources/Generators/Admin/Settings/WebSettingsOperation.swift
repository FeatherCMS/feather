import OpenAPIKit30
import WebSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator

public protocol WebSettingsOperation: BearerProtectedOperation {
}

extension WebSettingsOperation {
    public var tags: [any TagRepresentable] { [WebSettingsTag()] }
}
