import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

extension Menu.Key.Get {
    struct Operation: Menu.Operation {
        var operationId: String? { "webMenuGetByKey" }
        var parameters: [any ParameterRepresentable] {
            [WebMenuKeyParameter().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: WebMenuResponse().reference(),
                404: CustomResponse(description: "Web menu not found"),
            ]
        }
    }
}
