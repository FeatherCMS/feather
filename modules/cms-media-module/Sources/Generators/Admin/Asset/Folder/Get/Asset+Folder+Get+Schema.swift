import FeatherOpenAPI

extension Asset.Folder.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Asset.Folder.Schemas.ID().reference(),
                "parentId": Asset.Folder.Schemas.NullableID(),
                "name": Asset.Folder.Schemas.Name(),
                "slug": Asset.Folder.Schemas.Slug(),
                "slugPath": Asset.Folder.Schemas.SlugPath(),
                "assetCount": Asset.Folder.Schemas.Count(),
                "totalSizeBytes": Asset.Folder.Schemas.Bytes(),
                "createdAt": Asset.Folder.Schemas.Timestamp(),
                "updatedAt": Asset.Folder.Schemas.Timestamp(),
            ]
        }
    }

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MediaFolderDetailResponse" }
        var description: String = "MediaFolder response"
        var schema = Schema().reference()
    }
}
