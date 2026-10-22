import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebSharedOpenAPIGenerator

extension Page.ID.Get {
    struct Operation: Page.Operation {
        var operationId: String? { "webPageGet" }
        var parameters: [any ParameterRepresentable] {
            [WebMetadataIdParameter().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: WebPageDetailResponse().reference(),
                404: CustomResponse(description: "Web page not found"),
            ]
        }
    }
}
