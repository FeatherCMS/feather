import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct WebMetadataGetOperation: WebOperation {
    var parameters: [any ParameterRepresentable] {
        [WebMetadataSlugParameter().reference()]
    }

    var responseMap: ResponseMap {
        [
            200: WebMetadataResponse().reference(),
            404: CustomResponse(description: "Web metadata not found"),
        ]
    }
}

struct WebMetadataListOperation: WebOperation {
    var responseMap: ResponseMap {
        [200: WebMetadataListResponse().reference()]
    }
}
