import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.Post {
    struct Operation: Author.Operation {
        var operationId: String? { "blogAuthorPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogAuthorRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: BlogAuthorDetailResponse().reference()]
        }
    }
}
