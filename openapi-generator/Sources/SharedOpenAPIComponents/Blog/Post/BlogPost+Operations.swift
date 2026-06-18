import FeatherOpenAPI
import OpenAPIKit30

struct BlogPostListOperation: BlogOperation {
    var responseMap: ResponseMap {
        [200: BlogPostListResponse().reference()]
    }
}

struct BlogPostGetOperation: BlogOperation {
    var parameters: [ParameterRepresentable] {
        [BlogPostIdParameter().reference()]
    }

    var responseMap: ResponseMap {
        [
            200: BlogPostDetailResponse().reference(),
            404: CustomResponse(description: "Blog post not found"),
        ]
    }
}
