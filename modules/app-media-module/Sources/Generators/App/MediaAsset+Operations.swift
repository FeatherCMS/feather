import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKitCore

struct MediaAssetResolveOperation: OperationRepresentable {
    var tags: [any TagRepresentable] {
        [MediaAssetTag()]
    }

    var requestBody: (any RequestBodyRepresentable)? {
        MediaAssetResolveRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: MediaAssetResolveResponse().reference()
        ]
    }
}
