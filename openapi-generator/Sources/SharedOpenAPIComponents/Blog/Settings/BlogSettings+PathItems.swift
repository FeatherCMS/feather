import FeatherOpenAPI

public struct BlogRouteSettingsPathItems: PathItemRepresentable {
    public var get: OperationRepresentable? { BlogRouteSettingsOperation() }

    public init() {}
}
