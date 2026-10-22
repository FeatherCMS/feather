import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthorLink.List {
    struct Operation: BlogAuthorLink.Operation {
        var operationId: String? { "blogAuthorLinkList" }
        var responseMap: ResponseMap {
            [200: BlogAuthorLinkListResponse().reference()]
        }
    }
}
