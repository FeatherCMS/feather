import FeatherOpenAPI

extension Profile.Schemas {
    struct Name: StringSchemaRepresentable {
        var required: Bool
        var nullable: Bool { true }

        init(required: Bool = true) {
            self.required = required
        }

    }
}
