import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

extension Menu.List {
    struct Operation: Menu.Operation {
        var operationId: String? { "webMenuList" }
        var responseMap: ResponseMap {
            [200: WebMenuListResponse().reference()]
        }
    }
}
