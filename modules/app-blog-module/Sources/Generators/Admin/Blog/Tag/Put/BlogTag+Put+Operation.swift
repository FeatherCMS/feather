import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogTag.Put {
    struct Operation: BlogTag.IdentifiableOperation {
        var operationId: String? { "blogTagPut" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogTagUpdateRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogTagDetailResponse().reference(),
                404: CustomResponse(description: "Blog tag not found"),
            ]
        }
    }
}
