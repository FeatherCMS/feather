import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.File.Resolve {
    struct Operation: Asset.File.Operation {
        var operationId: String? { "mediaAssetResolve" }
        var requestBody: (any RequestBodyRepresentable)? {
            MediaAssetResolveRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [200: MediaAssetResolveResponse().reference()]
        }
    }
}
