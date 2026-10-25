import FeatherOpenAPI

extension Post.Schemas {
    struct TagIDs: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "BlogPostTagIdsField" }
        var items: (any SchemaRepresentable)? {
            Tag.Schemas.ID().reference()
        }
    }
}
