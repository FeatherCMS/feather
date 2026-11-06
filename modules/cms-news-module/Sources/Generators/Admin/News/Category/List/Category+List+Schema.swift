import FeatherOpenAPI

extension Category.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "NewsCategoryListSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }
}
