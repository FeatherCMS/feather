import FeatherOpenAPI

extension AuthorLink.Get {
    struct Response: JSONResponseRepresentable {
        var description: String = "Blog author link response"
        var schema = Schema().reference()
    }

    struct Schema: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "id": AuthorLink.Schemas.ID(),
                "menuId": Author.Schemas.ID(),
                "label": AuthorLink.Schemas.Label(),
                "url": AuthorLink.Schemas.URL(),
                "priority": AuthorLink.Schemas.Priority(),
                "isBlank": AuthorLink.Schemas.IsBlank(),
                "permission": AuthorLink.Schemas.Permission(),
                "notes": AuthorLink.Schemas.Notes(),
                "createdAt": AuthorLink.Schemas.CreatedAt(),
                "updatedAt": AuthorLink.Schemas.UpdatedAt(),
            ]
        }
    }
}
