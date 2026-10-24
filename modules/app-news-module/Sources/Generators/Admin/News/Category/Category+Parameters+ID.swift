import FeatherOpenAPI

extension Category.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "NewsCategoryIDParameter" }
        var name: String { "newsCategoryId" }
        var description: String? { "News category identifier" }
        var schema: any OpenAPISchemaRepresentable {
            NewsAdminOpenAPIComponents.StringField().reference()
        }
    }
}
