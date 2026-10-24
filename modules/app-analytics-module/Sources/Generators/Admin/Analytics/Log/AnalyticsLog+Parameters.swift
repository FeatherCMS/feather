import FeatherOpenAPI

struct AnalyticsLogIdParameter: PathParameterRepresentable {
    var name: String { "id" }
    var description: String? { "Analytics log identifier" }
    var schema: any OpenAPISchemaRepresentable {
        AnalyticsLogIdField().reference()
    }
}
