import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct MediaVariantIdField: StringSchemaRepresentable {
    var example: String? = "V1StGXR8_Z5jdHi6B-myT"
}
struct MediaVariantKeyField: StringSchemaRepresentable {
    var example: String? = "preview"
}
struct MediaVariantNameField: StringSchemaRepresentable {
    var example: String? = "Preview"
}
struct MediaVariantExtensionsField: StringSchemaRepresentable {
    var example: String? = "png,jpg,jpeg,bmp"
}
struct MediaVariantCommandField: StringSchemaRepresentable {
    var example: String? =
        "convert {input.fullname} -resize 256x256 {output.fullname}"
}
struct MediaVariantBooleanField: BoolSchemaRepresentable {
    var example: Bool? = true
}
struct MediaVariantTimestampField: DoubleSchemaRepresentable {
    var example: Double? = 1_717_171_717
}

struct MediaVariantProcessorListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MediaVariantIdField().reference(),
            "name": MediaVariantNameField(),
            "matchExtensions": MediaVariantExtensionsField(),
            "commandTemplate": MediaVariantCommandField(),
            "isActive": MediaVariantBooleanField(),
        ]
    }
}

struct MediaVariantProcessorDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MediaVariantIdField().reference(),
            "variantId": MediaVariantIdField().reference(),
            "name": MediaVariantNameField(),
            "matchExtensions": MediaVariantExtensionsField(),
            "commandTemplate": MediaVariantCommandField(),
            "isActive": MediaVariantBooleanField(),
            "createdAt": MediaVariantTimestampField(),
            "updatedAt": MediaVariantTimestampField(),
        ]
    }
}

struct MediaVariantProcessorListField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        MediaVariantProcessorListItemSchema().reference()
    }
}

struct MediaVariantCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "key": MediaVariantKeyField(),
            "name": MediaVariantNameField(),
            "isRequired": MediaVariantBooleanField(),
            "isActive": MediaVariantBooleanField(),
        ]
    }
}

struct MediaVariantDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MediaVariantIdField().reference(),
            "key": MediaVariantKeyField(),
            "name": MediaVariantNameField(),
            "isRequired": MediaVariantBooleanField(),
            "isActive": MediaVariantBooleanField(),
            "processors": MediaVariantProcessorListField(),
            "createdAt": MediaVariantTimestampField(),
            "updatedAt": MediaVariantTimestampField(),
        ]
    }
}

struct MediaVariantListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MediaVariantIdField().reference(),
            "key": MediaVariantKeyField(),
            "name": MediaVariantNameField(),
            "isRequired": MediaVariantBooleanField(),
            "isActive": MediaVariantBooleanField(),
        ]
    }
}

struct MediaVariantProcessorCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "name": MediaVariantNameField(),
            "matchExtensions": MediaVariantExtensionsField(),
            "commandTemplate": MediaVariantCommandField(),
            "isActive": MediaVariantBooleanField(),
        ]
    }
}
