import FeatherOpenAPI

extension Profile.Schemas {
    struct ImageAssetID: StringSchemaRepresentable {
        var required: Bool
        var nullable: Bool { true }

        init(required: Bool = true) {
            self.required = required
        }

    }
}
