import FeatherOpenAPI

extension Contact.Field.Schemas {
    struct AllowedValues: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "ContactAllowedValuesSchema" }
        var items: (any SchemaRepresentable)? {
            AllowedValue()
        }
    }

    struct IDs: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "ContactFieldIDsSchema" }
        var items: (any SchemaRepresentable)? { Contact.Schemas.ID() }
    }

    struct FormFields: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "FormFieldsSchema" }
        var items: (any SchemaRepresentable)? {
            Contact.Field.Get.Schema().reference()
        }
    }
}
