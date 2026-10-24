import FeatherOpenAPI

extension Contact.Form.Submission {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AppContactFormSubmissionSchema" }
        var propertyMap: SchemaMap {
            [
                "values": Contact.Schemas.JSON(),
                "metadata": Contact.Schemas.JSON().reference(required: false),
            ]
        }
    }

}
