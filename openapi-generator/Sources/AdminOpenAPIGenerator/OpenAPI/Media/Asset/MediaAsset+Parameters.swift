import FeatherOpenAPI

struct MediaAssetIdParameter: PathParameterRepresentable {
    var name: String { "mediaAssetId" }
    var description: String? { "MediaAsset id" }
    var schema: any OpenAPISchemaRepresentable {
        MediaAssetIdField().reference()
    }
}
