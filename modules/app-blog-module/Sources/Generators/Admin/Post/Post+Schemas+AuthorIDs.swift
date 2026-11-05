import FeatherOpenAPI

extension Post.Schemas {
    struct AuthorIDs: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "BlogPostAuthorIdsField" }
        var items: (any SchemaRepresentable)? {
            Author.Schemas.ID().reference()
        }
    }
}
