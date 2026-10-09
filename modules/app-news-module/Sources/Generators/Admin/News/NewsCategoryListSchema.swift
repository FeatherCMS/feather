import FeatherOpenAPI
import OpenAPIKit30

struct NewsCategoryListSchema: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? {
        NewsCategoryListItemSchema().reference()
    }
}
