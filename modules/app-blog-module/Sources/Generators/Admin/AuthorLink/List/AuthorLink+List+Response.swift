import FeatherOpenAPI

extension AuthorLink.List {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog author link list response"
        var schema = Schema().reference()
    }

    struct Schema: ArraySchemaRepresentable {
        var items: (any SchemaRepresentable)? {
            ItemSchema().reference()
        }
    }

    struct ItemSchema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": AuthorLink.Schemas.ID().reference(),
                "menuId": Author.Schemas.ID().reference(),
                "label": AuthorLink.Schemas.Label().reference(),
                "url": AuthorLink.Schemas.URL().reference(),
                "priority": AuthorLink.Schemas.Priority().reference(),
                "isBlank": AuthorLink.Schemas.IsBlank().reference(),
                "permission": AuthorLink.Schemas.Permission().reference(),
                "createdAt": AuthorLink.Schemas.CreatedAt().reference(),
                "updatedAt": AuthorLink.Schemas.UpdatedAt().reference(),
            ]
        }
    }
}
