import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Page.ID.Get {
    struct Operation: Page.Operation {
        var operationId: String? { "pageGet" }
        var parameters: [any ParameterRepresentable] {
            [MetadataIdParameter().reference()]
        }
        var responseMap: ResponseMap {
            [
                200: PageDetailResponse().reference(),
                404: CustomResponse(description: "Web page not found"),
            ]
        }
    }
}
