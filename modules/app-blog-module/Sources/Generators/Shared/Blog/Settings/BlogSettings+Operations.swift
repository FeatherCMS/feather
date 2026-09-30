public import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

public protocol BlogOperation: OperationRepresentable {}

extension BlogOperation {
    public var tags: [any TagRepresentable] { [BlogContentTag()] }
}

struct BlogRouteSettingsOperation: BlogOperation {
    var responseMap: ResponseMap {
        [200: BlogRouteSettingsResponse().reference()]
    }
}
