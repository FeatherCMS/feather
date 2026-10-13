import FeatherOpenAPI

struct AccountSettingsUserIDParameter: PathParameterRepresentable {
    var name: String { "userId" }
    var schema: any OpenAPISchemaRepresentable {
        AccountSettingsUserIDField().reference()
    }
}

struct AccountSettingsUserIDField: StringSchemaRepresentable {}
