import FeatherOpenAPI

extension Rule.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleIdField" }
        var example: String? = "rr_home_old"
    }

    struct Source: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleSourceField" }
        var example: String? = "/old-home"
    }

    struct Destination: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleDestinationField" }
        var example: String? = "/new-home"
    }

    struct StatusCode: IntSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleStatusCodeField" }
        var example: Int? = 301
        var enumValues: [Int]? = [301, 302, 307, 308]
    }

    struct Search: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleSearchField" }
        var example: String? = "/old-home"
    }

    struct Notes: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleNotesField" }
        var example: String? = "Legacy homepage redirect."
    }

    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleUpdateMask" }
        var example: String? = "source,destination,statusCode,notes"
    }

    struct Create: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "RedirectRuleCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "source": Source(),
                "destination": Destination(),
                "statusCode": StatusCode(),
                "notes": Notes().reference(required: false),
            ]
        }
    }
}
