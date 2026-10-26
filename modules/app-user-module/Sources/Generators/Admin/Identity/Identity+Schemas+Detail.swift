import FeatherOpenAPI

extension Identity.Schemas {
    struct Detail: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "UserIdentityDetailSchema" }

        var propertyMap: SchemaMap {
            [
                "id": ID().reference(),
                "name": Name().reference(),
                "status": Status().reference(),
                "roleIds": RoleIDList().reference(required: false),
            ]
        }
    }
}
