import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension AuthorLink.Post {
    struct Operation: AuthorLink.Operation {
        var operationId: String? { "blogAuthorLinkPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogAuthorLinkRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: BlogAuthorLinkDetailResponse().reference()]
        }
    }
}
