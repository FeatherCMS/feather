import FeatherOpenAPI
import OpenAPIKit30

struct BlogTagListOperation: BlogOperation {
    var responseMap: ResponseMap {
        [200: BlogTagListResponse().reference()]
    }
}

struct BlogTagGetOperation: BlogOperation {
    var parameters: [ParameterRepresentable] {
        [BlogTagIdParameter().reference()]
    }

    var responseMap: ResponseMap {
        [
            200: BlogTagDetailResponse().reference(),
            404: CustomResponse(description: "Blog tag not found"),
        ]
    }
}
