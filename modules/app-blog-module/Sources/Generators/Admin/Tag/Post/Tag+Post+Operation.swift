import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag.Post {
    struct Operation: Tag.Operation {
        var operationId: String? { "blogTagPost" }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [201: Tag.Get.Response().reference()]
        }
    }
}
