import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Menu.List {
    struct Operation: Menu.Operation {
        var operationId: String? { "menuList" }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
