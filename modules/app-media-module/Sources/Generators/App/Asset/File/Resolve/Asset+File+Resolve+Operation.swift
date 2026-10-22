import FeatherOpenAPI

extension Asset.File.Resolve {
    struct Operation: OperationRepresentable {
        var operationId: String? { "mediaAssetResolve" }
        var tags: [any TagRepresentable] { [MediaAssetTag()] }
        var requestBody: (any RequestBodyRepresentable)? {
            MediaAssetResolveRequestBody().reference()
        }
        var responseMap: ResponseMap {
            [200: MediaAssetResolveResponse().reference()]
        }
    }
}
