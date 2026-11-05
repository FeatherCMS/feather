import FeatherOpenAPI

extension Analytics.Log.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogIdParameter" }
        var name: String { "id" }
        var description: String? { "Analytics log identifier" }
        var schema: any OpenAPISchemaRepresentable {
            Analytics.Log.Schemas.ID().reference()
        }
    }
}
