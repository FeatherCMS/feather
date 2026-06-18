import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

struct MediaFolderIdField: StringSchemaRepresentable {
    var example: String? = "media_folder_blog_posts"
}

struct MediaFolderNameField: StringSchemaRepresentable {
    var example: String? = "Posts"
}

struct MediaFolderPathField: StringSchemaRepresentable {
    var example: String? = "blog/posts"
}

struct MediaFolderCountField: IntSchemaRepresentable {
    var example: Int? = 3
}

struct MediaFolderBytesField: SchemaRepresentable {
    func openAPISchema() -> JSONSchema {
        .integer(
            format: .int64,
            required: required,
            nullable: nullable,
            deprecated: deprecated,
            title: title,
            description: description
        )
    }
}

struct MediaFolderTimestampField: DoubleSchemaRepresentable {
    var example: Double? = 1_717_171_717
}

struct MediaFolderNullableIdField: SchemaRepresentable {
    var required: Bool = false

    func openAPISchema() -> JSONSchema {
        .string(
            required: required,
            nullable: true,
            deprecated: deprecated,
            title: title,
            description: description
        )
    }
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
            "name": MediaFolderNameField()
        ]
    }
}

struct MediaFolderFiltersSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "parentId": MediaFolderNullableIdField()
        ]
    }
}

struct MediaFolderDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MediaFolderIdField().reference(),
            "parentId": MediaFolderNullableIdField(),
            "name": MediaFolderNameField(),
            "path": MediaFolderPathField(),
            "assetCount": MediaFolderCountField(),
            "totalSizeBytes": MediaFolderBytesField(),
            "createdAt": MediaFolderTimestampField(),
            "updatedAt": MediaFolderTimestampField(),
        ]
    }
}

struct MediaFolderListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MediaFolderIdField().reference(),
            "parentId": MediaFolderNullableIdField(),
            "name": MediaFolderNameField(),
            "path": MediaFolderPathField(),
            "assetCount": MediaFolderCountField(),
            "totalSizeBytes": MediaFolderBytesField(),
            "createdAt": MediaFolderTimestampField(),
            "updatedAt": MediaFolderTimestampField(),
        ]
    }
}
