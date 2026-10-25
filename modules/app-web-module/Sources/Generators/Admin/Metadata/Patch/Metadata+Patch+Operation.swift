import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Metadata.Patch {
    struct Operation: Metadata.IdentifiableOperation, BearerProtectedOperation {
        var operationId: String? { "metadataPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                Metadata.Parameters.ID().reference(),
                Metadata.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Metadata.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Metadata not found"),
            ]
        }
    }
}
