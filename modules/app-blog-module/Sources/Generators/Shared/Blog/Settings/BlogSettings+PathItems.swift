public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct BlogRouteSettingsPathItems: PathItemRepresentable {
    public var get: (any OperationRepresentable)? { BlogRouteSettingsOperation() }

    public init() {}
}
