import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension AuthorLink.List {
    struct Operation: AuthorLink.Operation {
        var operationId: String? { "blogAuthorLinkList" }
        var responseMap: ResponseMap {
            [200: BlogAuthorLinkListResponse().reference()]
        }
    }
}
