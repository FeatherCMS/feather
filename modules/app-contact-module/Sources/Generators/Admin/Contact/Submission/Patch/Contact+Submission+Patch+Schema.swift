import FeatherOpenAPI

extension Contact.Submission.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String {
            "ContactFormSubmissionPatchSchema"
        }
        var propertyMap: SchemaMap {
            [
                "status": Contact.Submission.Schemas.Status()
                    .reference(
                        required: false
                    )
            ]
        }
    }

    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String {
            "ContactFormSubmissionPatchRequestBody"
        }
        var schema = Schema().reference()
    }
}
