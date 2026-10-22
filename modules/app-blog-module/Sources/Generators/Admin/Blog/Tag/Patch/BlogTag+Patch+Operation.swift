import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogTag.Patch {
    struct Operation: BlogTag.IdentifiableOperation {
        var operationId: String? { "blogTagPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                BlogTagIdParameter().reference(),
                BlogTag.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            BlogTagPatchRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: BlogTagDetailResponse().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Blog tag not found"),
            ]
        }
    }
}
