import FeatherOpenAPI
import OpenAPIKit30

struct WebPageGetOperation: WebOperation {
    var parameters: [ParameterRepresentable] {
        [WebMetadataIdParameter().reference()]
    }

    var responseMap: ResponseMap {
        [
            200: WebPageDetailResponse().reference(),
            404: CustomResponse(description: "Web page not found"),
        ]
    }
}
