import FeatherOpenAPI
import OpenAPIKit30

public struct RedirectSourceField: StringSchemaRepresentable {
    public var example: String? = "/from-here/"

    public init() {}
}

public struct RedirectDestinationField: StringSchemaRepresentable {
    public var example: String? = "/to-there/"

    public init() {}
}

public struct RedirectStatusCodeField: IntSchemaRepresentable {
    public var enumValues: [Int]? = [301, 302, 307, 308]
    public var example: Int? = 301

    public init() {}
}

public struct RedirectRuleSchema: ObjectSchemaRepresentable {
    public var propertyMap: SchemaMap {
        [
            "source": RedirectSourceField().reference(),
            "destination": RedirectDestinationField().reference(),
            "statusCode": RedirectStatusCodeField().reference(),
        ]
    }

    public init() {}
}
