import FeatherOpenAPI

extension Contact.Submission.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "ContactFormSubmissionSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Contact.Schemas.ID(),
                "formKey": Contact.Schemas.FormKey(),
                "values": Contact.Schemas.JSON(),
                "itemsSnapshot": Contact.Schemas.JSON(),
                "metadata": Contact.Schemas.JSON(),
                "status": Contact.Submission.Schemas.Status(),
                "createdAt": Contact.Schemas.Timestamp(),
                "updatedAt": Contact.Schemas.Timestamp(),
            ]
        }
    }

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "ContactFormSubmissionResponse" }
        var description: String = "Contact form submission response"
        var schema = Schema().reference()
    }
}
