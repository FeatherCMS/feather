import FeatherOpenAPI

extension Variable.Parameters {
    struct Search: QueryParameterRepresentable {
        var name: String { "search" }
        var required: Bool { false }
        var description: String? {
            "Search across variable keys, values, names, and notes"
        }
        var schema: any OpenAPISchemaRepresentable {
            Variable.Schemas.Search().reference()
        }
    }

    struct IDs: QueryParameterRepresentable {
        var name: String { "ids" }
        var required: Bool { false }
        var description: String? { "Filter by one or more variable IDs" }
        var schema: any OpenAPISchemaRepresentable {
            Variable.Query.Schemas.Filter().reference()
        }
    }

    struct Limit: QueryParameterRepresentable {
        var name: String { "limit" }
        var required: Bool { false }
        var description: String? {
            "Defaults to 20; values are clamped to 1-100"
        }
        var schema: any OpenAPISchemaRepresentable {
            Variable.Schemas.Limit().reference()
        }
    }

    struct UpdateMask: QueryParameterRepresentable {
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated list of fields to update. Include an optional field to clear it when omitted from the request body."
        }
        var schema: any OpenAPISchemaRepresentable {
            Variable.Schemas.UpdateMask().reference()
        }
    }

    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "SystemVariableIDParameter" }
        var name: String { "systemVariableId" }
        var description: String? { "SystemVariable ID" }
        var schema: any OpenAPISchemaRepresentable {
            Variable.Schemas.ID().reference()
        }
    }
}
