import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

extension Menu.Key.Get {
    struct Operation: Menu.Operation {
        var operationId: String? { "menuGetByKey" }
        var parameters: [any ParameterRepresentable] {
            [MenuKeyParameter().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: MenuResponse().reference(),
                404: CustomResponse(description: "Web menu not found"),
            ]
        }
    }
}
