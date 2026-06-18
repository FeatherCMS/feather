import FeatherOpenAPI
import OpenAPIKit30

public protocol BlogOperation: OperationRepresentable {}

extension BlogOperation {
    public var tags: [TagRepresentable] { [BlogContentTag()] }
}

struct BlogRouteSettingsOperation: BlogOperation {
    var responseMap: ResponseMap {
        [200: BlogRouteSettingsResponse().reference()]
    }
}
