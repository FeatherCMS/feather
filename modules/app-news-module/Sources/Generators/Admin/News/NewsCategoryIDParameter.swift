import FeatherOpenAPI

struct NewsCategoryIDParameter: PathParameterRepresentable {
    var name: String { "newsCategoryId" }
    var description: String? { "News category identifier" }
    var schema: any OpenAPISchemaRepresentable {
        NewsAdminOpenAPIComponents.StringField().reference()
    }
}
