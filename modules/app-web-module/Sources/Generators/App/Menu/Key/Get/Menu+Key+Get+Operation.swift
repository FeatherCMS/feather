import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Menu.Key.Get {
    struct Operation: Menu.Operation {
        var operationId: String? { "menuGetByKey" }
        var parameters: [any ParameterRepresentable] {
            [Menu.Parameters.Key().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Web menu not found"),
            ]
        }
    }
}
