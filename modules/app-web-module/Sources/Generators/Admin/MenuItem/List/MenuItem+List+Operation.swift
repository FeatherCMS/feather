import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebOpenAPIGeneratorSupport

extension MenuItem.List {
    struct Operation: MenuItem.MenuOperation, BearerProtectedOperation {
        var operationId: String? { "menuItemList" }
        var responseMap: ResponseMap {
            [
                200: MenuItemListResponse().reference()
            ]
        }
    }
}
