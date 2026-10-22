import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthorLink.Post {
    struct Operation: BlogAuthorLink.Operation {
        var operationId: String? { "blogAuthorLinkPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogAuthorLinkRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: BlogAuthorLinkDetailResponse().reference()]
        }
    }
}
