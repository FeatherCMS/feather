import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag.Get {
    struct Operation: Tag.IdentifiableOperation {
        var operationId: String? { "blogTagGet" }
        var responseMap: ResponseMap {
            [
                200: BlogTagDetailResponse().reference(),
                404: CustomResponse(description: "Blog tag not found"),
            ]
        }
    }
}
