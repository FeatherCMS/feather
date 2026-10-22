import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag.Put {
    struct Operation: Tag.IdentifiableOperation {
        var operationId: String? { "blogTagPut" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Tag.Get.Response().reference(),
                404: CustomResponse(description: "Blog tag not found"),
            ]
        }
    }
}
