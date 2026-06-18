import FeatherOpenAPI
import OpenAPIKit30

struct WebMetadataGetOperation: WebOperation {
    var parameters: [ParameterRepresentable] {
        [WebMetadataSlugParameter().reference()]
    }

    var responseMap: ResponseMap {
        [
            200: WebMetadataResponse().reference(),
            404: CustomResponse(description: "Web metadata not found"),
        ]
    }
}
