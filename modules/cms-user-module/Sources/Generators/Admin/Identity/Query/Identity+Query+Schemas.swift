import FeatherOpenAPI

extension Identity.Query {
    enum Schemas {}
}

extension Identity.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Identity.Schemas.ID().reference(),
                "name": Identity.Schemas.Name().reference(),
                "status": Identity.Schemas.Status().reference(),
                "roles": Identity.Schemas.RoleNames().reference(),
            ]
        }
    }
}
