import FeatherOpenAPI

extension Asset.File.Query.Schemas {
    struct Filters: ObjectSchemaRepresentable {
        var propertyMap: SchemaMap {
            [
                "search": MediaAssetNullableTextField(required: false),
                "parentId": MediaFolderNullableIdField(),
            ]
        }
    }

    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetNodeQueryItemSchema" }
        var propertyMap: SchemaMap {
            [
                "kind": MediaAssetSearchItemKindField(),
                "file": File().reference(required: false),
                "folder": Folder().reference(required: false),
            ]
        }
    }

    struct File: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetQueryItemFileSchema" }
        var propertyMap: SchemaMap {
            [
                "id": MediaAssetIdField().reference(),
                "folderId": MediaFolderNullableIdField(),
                "name": MediaAssetFileNameField(),
                "slug": MediaAssetSlugField(),
                "slugPath": MediaAssetSlugPathField(),
                "url": MediaAssetURLField(),
                "extension": MediaAssetTypeField(),
                "contentType": MediaAssetContentTypeField(),
                "sizeBytes": MediaAssetSizeBytesField(),
                "status": MediaAssetStatusField(),
                "title": MediaAssetNullableTextField(required: false),
                "altText": MediaAssetNullableTextField(required: false),
                "createdAt": MediaAssetTimestampField(),
                "updatedAt": MediaAssetTimestampField(),
            ]
        }
    }

    struct Folder: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetQueryItemFolderSchema" }
        var propertyMap: SchemaMap {
            [
                "id": MediaFolderIdField().reference(),
                "parentId": MediaFolderNullableIdField(),
                "name": MediaFolderNameField(),
                "slug": MediaFolderSlugField(),
                "slugPath": MediaFolderSlugPathField(),
                "assetCount": MediaFolderCountField(),
                "totalSizeBytes": MediaFolderBytesField(),
                "createdAt": MediaFolderTimestampField(),
                "updatedAt": MediaFolderTimestampField(),
            ]
        }
    }
}
