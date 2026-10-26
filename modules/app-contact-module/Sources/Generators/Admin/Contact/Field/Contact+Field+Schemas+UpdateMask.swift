import FeatherOpenAPI

extension Contact.Field.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "ContactFormFieldUpdateMask" }
        var example: String? {
            "key,type,label,allowedValues,isRequired,position"
        }
    }
}
