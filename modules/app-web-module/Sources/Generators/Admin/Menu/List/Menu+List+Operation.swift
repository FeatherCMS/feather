import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.List {
    struct Operation: Menu.Operation, BearerProtectedOperation {
        var operationId: String? { "menuList" }
        var responseMap: ResponseMap {
            [200: MenuListResponse().reference()]
        }
    }
}
