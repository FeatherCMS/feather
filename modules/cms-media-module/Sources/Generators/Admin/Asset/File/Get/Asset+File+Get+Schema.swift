import FeatherOpenAPI

extension Asset.File.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetDetailSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Asset.File.Schemas.ID().reference(),
                "folderId": Asset.Folder.Schemas.NullableID(),
                "name": Asset.File.Schemas.FileName(),
                "slug": Asset.File.Schemas.Slug(),
                "slugPath": Asset.File.Schemas.SlugPath(),
                "url": Asset.File.Schemas.URL(),
                "extension": Asset.File.Schemas.FileExtension(),
                "contentType": Asset.File.Schemas.ContentType(),
                "sizeBytes": Asset.File.Schemas.SizeBytes(),
                "status": Asset.File.Schemas.Status(),
                "title": Asset.File.Schemas.NullableText(required: false),
                "altText": Asset.File.Schemas.NullableText(required: false),
                "createdAt": Asset.File.Schemas.Timestamp(),
                "updatedAt": Asset.File.Schemas.Timestamp(),
            ]
        }
    }

}
