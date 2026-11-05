import FeatherOpenAPI

extension Asset.File.Schemas {
    struct URL: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetURLField" }
        var example: String? { "/public/12/34/56789/originals/cover-image.jpg" }
    }
}
