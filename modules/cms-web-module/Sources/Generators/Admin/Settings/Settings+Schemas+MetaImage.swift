import FeatherOpenAPI

extension Settings.Schemas {
    struct MetaImage: StringSchemaRepresentable {
        var openAPIIdentifier: String { "SettingsMetaImageField" }
        var example: String? {
            "/public/12/34/56789/originals/default-meta-image.webp"
        }
    }
}
