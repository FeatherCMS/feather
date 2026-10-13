import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

enum NewsAdminOpenAPIComponents {
    struct StringField: StringSchemaRepresentable {
        var example: String? = "example"

        init() {}
    }

    struct TimestampField: DoubleSchemaRepresentable {
        var example: Double? { 1_760_000_000 }

        init() {}
    }

    struct BooleanField: BoolSchemaRepresentable {
        var example: Bool? = false

        init() {}
    }

    struct StatusField: StringSchemaRepresentable {
        var example: String? = "draft"
        var enumValues: [String]? = ["draft", "published", "archived"]

        init() {}
    }

    struct CategoryIDsField: ArraySchemaRepresentable {
        var items: (any SchemaRepresentable)? {
            StringField().reference()
        }

        init() {}
    }
}
