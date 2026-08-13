import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct WebSiteSettingsPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { WebSiteSettingsOperation() }

    public init() {}
}
