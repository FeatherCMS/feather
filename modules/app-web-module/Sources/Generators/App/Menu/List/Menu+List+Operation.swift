import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

extension Menu.List {
    struct Operation: Menu.Operation {
        var operationId: String? { "menuList" }
        var responseMap: ResponseMap {
            [200: MenuListResponse().reference()]
        }
    }
}
