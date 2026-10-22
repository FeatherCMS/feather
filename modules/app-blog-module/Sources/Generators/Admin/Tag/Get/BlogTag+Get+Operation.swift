import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogTag.Get {
    struct Operation: BlogTag.IdentifiableOperation {
        var operationId: String? { "blogTagGet" }
        var responseMap: ResponseMap {
            [
                200: BlogTagDetailResponse().reference(),
                404: CustomResponse(description: "Blog tag not found"),
            ]
        }
    }
}
