public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct WebSiteSettingsPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { WebSiteSettingsOperation() }

    public init() {}
}
