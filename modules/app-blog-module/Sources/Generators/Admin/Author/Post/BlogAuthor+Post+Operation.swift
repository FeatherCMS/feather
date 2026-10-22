import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthor.Post {
    struct Operation: BlogAuthor.Operation {
        var operationId: String? { "blogAuthorPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogAuthorRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: BlogAuthorDetailResponse().reference()]
        }
    }
}
