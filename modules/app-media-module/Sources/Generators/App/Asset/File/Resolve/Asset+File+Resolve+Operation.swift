import FeatherOpenAPI

extension Asset.File.Resolve {
    struct Operation: OperationRepresentable {
        var operationId: String? { "mediaAssetResolve" }
        var tags: [any TagRepresentable] { [Asset.File.Tag()] }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
