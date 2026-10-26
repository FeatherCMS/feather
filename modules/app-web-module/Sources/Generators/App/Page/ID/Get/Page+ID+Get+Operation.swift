import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Page.ID.Get {
    struct Operation: Page.Operation {
        var operationId: String? { "pageGet" }
        var parameters: [any ParameterRepresentable] {
            [Page.Parameters.ID().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "Web page not found"),
            ]
        }
    }
}
