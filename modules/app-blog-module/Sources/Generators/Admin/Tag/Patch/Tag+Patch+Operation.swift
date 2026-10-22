import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag.Patch {
    struct Operation: Tag.IdentifiableOperation {
        var operationId: String? { "blogTagPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                BlogTagIdParameter().reference(),
                Tag.Parameters.UpdateMask().reference(),
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
