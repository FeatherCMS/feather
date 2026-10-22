import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogTag.Post {
    struct Operation: BlogTag.Operation {
        var operationId: String? { "blogTagPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogTagRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: BlogTagDetailResponse().reference()]
        }
    }
}
