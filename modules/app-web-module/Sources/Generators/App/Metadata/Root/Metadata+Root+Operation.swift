import FeatherOpenAPI
import FeatherOpenAPIGenerator
import WebOpenAPIGeneratorSupport

extension Metadata.Root {
    struct Operation: Metadata.Operation {
        var operationId: String? { "metadataRootGet" }
        var responseMap: ResponseMap {
            [
                200: Metadata.Get.Response().reference(),
                404: CustomResponse(description: "Web metadata not found"),
            ]
        }
    }
}
