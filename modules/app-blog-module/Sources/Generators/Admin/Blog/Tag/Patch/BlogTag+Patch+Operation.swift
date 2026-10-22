import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogTag.Patch {
    struct Operation: BlogTag.IdentifiableOperation {
        var operationId: String? { "blogTagPatch" }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogTagPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogTagDetailResponse().reference(),
                404: CustomResponse(description: "Blog tag not found"),
            ]
        }
    }
}
