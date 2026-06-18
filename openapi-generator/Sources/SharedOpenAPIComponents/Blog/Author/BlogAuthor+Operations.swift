import FeatherOpenAPI
import OpenAPIKit30

struct BlogAuthorListOperation: BlogOperation {
    var responseMap: ResponseMap {
        [200: BlogAuthorListResponse().reference()]
    }
}

struct BlogAuthorGetOperation: BlogOperation {
    var parameters: [ParameterRepresentable] {
        [BlogAuthorIdParameter().reference()]
    }

    var responseMap: ResponseMap {
        [
            200: BlogAuthorDetailResponse().reference(),
            404: CustomResponse(description: "Blog author not found"),
        ]
    }
}
