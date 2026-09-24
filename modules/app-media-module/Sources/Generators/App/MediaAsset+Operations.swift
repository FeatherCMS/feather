import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKitCore

struct MediaAssetResolveOperation: OperationRepresentable {
    var tags: [TagRepresentable] {
        [MediaAssetTag()]
    }

    var requestBody: RequestBodyRepresentable? {
        MediaAssetResolveRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: MediaAssetResolveResponse().reference()
        ]
    }
}
