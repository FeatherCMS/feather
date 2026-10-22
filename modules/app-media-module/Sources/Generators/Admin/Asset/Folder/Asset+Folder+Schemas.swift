import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct MediaFolderIdField: StringSchemaRepresentable {
    var example: String? = "media_folder_blog_posts"
}

struct MediaFolderNameField: StringSchemaRepresentable {
    var example: String? = "Posts"
}

struct MediaFolderSlugField: StringSchemaRepresentable {
    var example: String? = "posts"
}

struct MediaFolderSlugPathField: StringSchemaRepresentable {
    var example: String? = "blog/posts"
}

struct MediaFolderCountField: IntSchemaRepresentable {
    var example: Int? = 3
}

struct MediaFolderBytesField: Int64SchemaRepresentable {}

struct MediaFolderTimestampField: DoubleSchemaRepresentable {
    var example: Double? = 1_717_171_717
}

struct MediaFolderNullableIdField: StringSchemaRepresentable {
    var required: Bool = false
    var nullable: Bool? = true
}

struct MediaFolderCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "parentId": MediaFolderNullableIdField(),
            "name": MediaFolderNameField(),
        ]
    }
}

struct MediaFolderPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "name": MediaFolderNameField().reference(required: false)
        ]
    }
}

struct MediaFolderUpdateMaskField: StringSchemaRepresentable {
    var example: String? = "name"
}

struct MediaFolderDetailSchema: ObjectSchemaRepresentable {
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
