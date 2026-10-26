import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Analytics.Log.Query {
    enum Schemas {}
}

extension Analytics.Log.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Analytics.Log.Schemas.ID().reference(),
                "accountId": Analytics.Log.Schemas.AccountID(),
                "source": Analytics.Log.Schemas.Source(),
                "method": Analytics.Log.Schemas.Method(),
                "path": Analytics.Log.Schemas.Path(),
                "responseCode": Analytics.Log.Schemas.ResponseCode(),
                "ip": Analytics.Log.Schemas.IP(),
                "browserName": Analytics.Log.Schemas.BrowserName(),
                "createdAt": Analytics.Log.Schemas.Timestamp(),
            ]
        }
    }

    struct Filter: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogFilterSchema" }
        var propertyMap: SchemaMap {
            [
                "search": Analytics.Log.Schemas.Path()
                    .reference(
                        required: false
                    ),
                "source": Analytics.Log.Schemas.Source()
                    .reference(
                        required: false
                    ),
                "method": Analytics.Log.Schemas.Method()
                    .reference(
                        required: false
                    ),
                "responseCode": Analytics.Log.Schemas.ResponseCode()
                    .reference(required: false),
                "from": Analytics.Log.Overview.Schemas.Date()
                    .reference(
                        required: false
                    ),
                "to": Analytics.Log.Overview.Schemas.Date()
                    .reference(
                        required: false
                    ),
            ]
        }

        var example: AnyCodable? {
            AnyCodable([
                "search": "/articles/hello-world/",
                "source": "web_app",
                "method": "GET",
            ])
        }
    }
}
