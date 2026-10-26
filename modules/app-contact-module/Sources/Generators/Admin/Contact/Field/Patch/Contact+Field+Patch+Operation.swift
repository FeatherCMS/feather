import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Field.Patch {
    struct Operation: Contact.Field.IDOperation {
        var operationId: String? { "contactFieldPatch" }
        var parameters: [any ParameterRepresentable] {
            [
                Contact.Field.Parameters.ID().reference(),
                Contact.Field.Parameters.UpdateMask().reference(),
            ]
        }
        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }
        var responseMap: ResponseMap {
            [
                200: Contact.Field.Get.Response().reference(),
                400: DefaultHTTPErrorContentResponse(
                    description: "Bad Request"
                ),
                404: CustomResponse(description: "Contact field not found"),
            ]
        }
    }

    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "FormFieldPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Contact.Field.Schemas.Key().reference(required: false),
                "type": Contact.Field.Schemas.FieldType()
                    .reference(required: false),
                "label": Contact.Field.Schemas.Label()
                    .reference(required: false),
                "allowedValues": Contact.Field.Schemas.AllowedValues()
                    .reference(required: false),
                "isRequired": Contact.Field.Schemas.Required()
                    .reference(required: false),
                "position": Contact.Field.Schemas.Position()
                    .reference(required: false),
            ]
        }
    }

    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String { "FormFieldPatchRequestBody" }
        var schema = Schema().reference()
    }
}
