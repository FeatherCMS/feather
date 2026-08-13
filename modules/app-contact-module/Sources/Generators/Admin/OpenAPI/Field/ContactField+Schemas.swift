import FeatherOpenAPI
import OpenAPIKit30

struct ContactLabelField: StringSchemaRepresentable {}
struct ContactKeyField: StringSchemaRepresentable {}
struct ContactTypeField: StringSchemaRepresentable {
    var enumValues: [String]? = [
        "text", "textarea", "select", "radio", "toggle",
    ]
}
struct ContactAllowedValueField: StringSchemaRepresentable {}
struct FormFieldPositionField: IntSchemaRepresentable {}
struct ContactRequiredField: BoolSchemaRepresentable {}

struct ContactAllowedValuesSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { ContactAllowedValueField() }
}
struct ContactFieldIDsSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { ContactIdField() }
}

struct FormFieldSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": ContactIdField(),
            "formId": ContactIdField(),
            "key": ContactKeyField(),
            "type": ContactTypeField(),
            "label": ContactLabelField(),
            "allowedValues": ContactAllowedValuesSchema()
                .reference(required: false),
            "isRequired": ContactRequiredField(),
            "position": FormFieldPositionField(),
            "createdAt": ContactTimestampField(),
            "updatedAt": ContactTimestampField(),
        ]
    }
}
struct FormFieldsSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { FormFieldSchema().reference() }
}
struct FormFieldListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { FormFieldSchema().reference() }
}
struct FormFieldCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": ContactKeyField(), "type": ContactTypeField(),
            "label": ContactLabelField(),
            "allowedValues": ContactAllowedValuesSchema()
                .reference(required: false),
            "isRequired": ContactRequiredField().reference(required: false),
            "position": FormFieldPositionField()
                .reference(required: false),
        ]
    }
}
struct FormFieldPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": ContactKeyField().reference(required: false),
            "type": ContactTypeField().reference(required: false),
            "label": ContactLabelField().reference(required: false),
            "allowedValues": ContactAllowedValuesSchema()
                .reference(required: false),
            "isRequired": ContactRequiredField().reference(required: false),
            "position": FormFieldPositionField()
                .reference(required: false),
        ]
    }
}
