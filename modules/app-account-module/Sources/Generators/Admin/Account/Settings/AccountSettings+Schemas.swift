import FeatherOpenAPI
import OpenAPIKit30

struct AccountSettingsLanguageField: StringSchemaRepresentable {}
struct AccountSettingsTimezoneField: StringSchemaRepresentable {}
struct AccountSettingsPageSizeField: IntSchemaRepresentable {}

struct AccountSettingsDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "language": AccountSettingsLanguageField(),
            "timezone": AccountSettingsTimezoneField(),
            "pageSize": AccountSettingsPageSizeField(),
        ]
    }
}

struct AccountSettingsUpdateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "language": AccountSettingsLanguageField(),
            "timezone": AccountSettingsTimezoneField(),
            "pageSize": AccountSettingsPageSizeField(),
        ]
    }
}
