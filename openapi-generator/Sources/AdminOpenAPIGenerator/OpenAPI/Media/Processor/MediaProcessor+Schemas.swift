import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

struct MediaProcessorIdField: StringSchemaRepresentable {
    var example: String? = "media_processor_image_thumb"
}

struct MediaProcessorNameField: StringSchemaRepresentable {
    var example: String? = "thumb"
}

struct MediaProcessorMatchExtensionsField: StringSchemaRepresentable {
    var example: String? = "png,jpg,jpeg"
}

struct MediaProcessorCommandTemplateField: StringSchemaRepresentable {
    var example: String? =
        "magick {input.fullname} -resize 64x64^ -gravity center -extent 64x64 {output.fullname}"
}

struct MediaProcessorFlagField: BoolSchemaRepresentable {
    var example: Bool? = true
}

struct MediaProcessorTimestampField: DoubleSchemaRepresentable {
    var example: Double? = 1_717_171_717
}

struct MediaProcessorCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "name": MediaProcessorNameField(),
            "matchExtensions": MediaProcessorMatchExtensionsField(),
            "commandTemplate": MediaProcessorCommandTemplateField(),
        ]
    }
}

struct MediaProcessorDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MediaProcessorIdField().reference(),
            "name": MediaProcessorNameField(),
            "matchExtensions": MediaProcessorMatchExtensionsField(),
            "commandTemplate": MediaProcessorCommandTemplateField(),
            "isRequired": MediaProcessorFlagField(),
            "isActive": MediaProcessorFlagField(),
            "createdAt": MediaProcessorTimestampField(),
            "updatedAt": MediaProcessorTimestampField(),
        ]
    }
}

struct MediaProcessorListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": MediaProcessorIdField().reference(),
            "name": MediaProcessorNameField(),
            "matchExtensions": MediaProcessorMatchExtensionsField(),
            "commandTemplate": MediaProcessorCommandTemplateField(),
            "isRequired": MediaProcessorFlagField(),
            "isActive": MediaProcessorFlagField(),
        ]
    }
}
