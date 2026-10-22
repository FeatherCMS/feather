public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol SettingsOperation: BearerProtectedOperation {
}

extension SettingsOperation {
    public var tags: [any TagRepresentable] { [SettingsTag()] }
}
