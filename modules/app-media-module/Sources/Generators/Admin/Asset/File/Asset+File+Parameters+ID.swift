import FeatherOpenAPI

extension Asset.File.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "MediaAssetIdParameter" }
        var name: String { "mediaAssetId" }
        var description: String? { "MediaAsset id" }
        var schema: any OpenAPISchemaRepresentable {
            Asset.File.Schemas.ID().reference()
        }
    }
}
