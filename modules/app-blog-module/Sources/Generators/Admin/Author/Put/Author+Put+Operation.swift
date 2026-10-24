import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.Put {
    struct Operation: Author.ID.Operation {
        var operationId: String? { "blogAuthorPut" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Author.Get.Response().reference(),
                404: CustomResponse(description: "Blog author not found"),
            ]
        }
    }
}
