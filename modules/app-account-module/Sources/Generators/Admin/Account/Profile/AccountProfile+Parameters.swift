import FeatherOpenAPI

struct AccountProfileUserIDParameter: PathParameterRepresentable {
    var name: String { "userId" }
    var schema: any OpenAPISchemaRepresentable {
        AccountProfileUserIDField().reference()
    }
}

struct AccountProfileUserIDField: StringSchemaRepresentable {}
