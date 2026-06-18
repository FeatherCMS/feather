import FeatherOpenAPI
import OpenAPIKit30

struct RedirectRuleIdField: StringSchemaRepresentable {
    var example: String? = "rr_home_old"
}

struct RedirectRuleSourceField: StringSchemaRepresentable {
    var example: String? = "/old-home"
}

struct RedirectRuleDestinationField: StringSchemaRepresentable {
    var example: String? = "/new-home"
}

struct RedirectRuleStatusCodeField: IntSchemaRepresentable {
    var example: Int? = 301
    var enumValues: [Int]? = [301, 302, 307, 308]
}

struct RedirectRuleSearchField: StringSchemaRepresentable {
    var example: String? = "/old-home"
}

struct RedirectRuleNotesField: StringSchemaRepresentable {
    var example: String? = "Legacy homepage redirect."
}

struct RedirectRuleCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "source": RedirectRuleSourceField(),
            "destination": RedirectRuleDestinationField(),
            "statusCode": RedirectRuleStatusCodeField(),
            "notes": RedirectRuleNotesField().reference(required: false),
        ]
    }
}

struct RedirectRulePatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "source": RedirectRuleSourceField().reference(required: false),
            "destination": RedirectRuleDestinationField()
                .reference(required: false),
            "statusCode": RedirectRuleStatusCodeField()
                .reference(required: false),
            "notes": RedirectRuleNotesField().reference(required: false),
        ]
    }
}

struct RedirectRuleDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": RedirectRuleIdField(),
            "source": RedirectRuleSourceField(),
            "destination": RedirectRuleDestinationField(),
            "statusCode": RedirectRuleStatusCodeField(),
            "notes": RedirectRuleNotesField(),
        ]
    }
}

struct RedirectRuleListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": RedirectRuleIdField().reference(),
            "source": RedirectRuleSourceField().reference(),
            "destination": RedirectRuleDestinationField().reference(),
            "statusCode": RedirectRuleStatusCodeField().reference(),
        ]
    }
}

struct RedirectRuleListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { RedirectRuleListItemSchema().reference() }
}

struct RedirectRuleFiltersSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "search": RedirectRuleSearchField().reference(required: false),
            "statusCode":
                RedirectRuleStatusCodeField().reference(required: false),
        ]
    }
}
