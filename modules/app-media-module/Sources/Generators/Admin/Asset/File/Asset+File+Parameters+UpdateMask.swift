import FeatherOpenAPI

extension Asset.File.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var openAPIIdentifier: String { "MediaAssetUpdateMaskParameter" }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated fields to update. Include an optional field to clear it when omitted from the body."
        }
        var schema: any OpenAPISchemaRepresentable {
            Asset.File.Schemas.UpdateMask().reference()
        }
    }
}
