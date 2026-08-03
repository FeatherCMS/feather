import FeatherOpenAPI
import OpenAPIKit30

struct AccountSettingsIdField: StringSchemaRepresentable {
    var example: String? = "account-settings-user_1"
}

struct AccountSettingsAccountIDField: StringSchemaRepresentable {
    var example: String? = "user_1"
}

struct AccountSettingsLanguageField: StringSchemaRepresentable {
    var example: String? = "en"
}

struct AccountSettingsTimezoneField: StringSchemaRepresentable {
    var example: String? = "Europe/Budapest"
}

struct AccountSettingsPageSizeField: IntSchemaRepresentable {
    var example: Int? = 20
    var enumValues: [Int]? = [10, 20, 50, 100]
}

struct AccountSettingsTimestampField: DoubleSchemaRepresentable {
    var example: Double? = 1_759_521_600
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

struct AccountSettingsDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": AccountSettingsIdField(),
            "accountID": AccountSettingsAccountIDField(),
            "language": AccountSettingsLanguageField(),
            "timezone": AccountSettingsTimezoneField(),
            "pageSize": AccountSettingsPageSizeField(),
            "createdAt": AccountSettingsTimestampField(),
            "updatedAt": AccountSettingsTimestampField(),
        ]
    }
}
