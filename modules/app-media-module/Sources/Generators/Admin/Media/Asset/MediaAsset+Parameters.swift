import FeatherOpenAPI

struct MediaAssetParentIDHeader: HeaderParameterRepresentable {
    var name: String { "X-Media-Asset-Parent-ID" }
    var required: Bool { false }
    var description: String? { "Optional parent folder id" }
    var schema: any OpenAPISchemaRepresentable {
        MediaAssetHeaderValueField()
    }
}

struct MediaAssetFileNameHeader: HeaderParameterRepresentable {
    var name: String { "X-Media-Asset-File-Name" }
    var description: String? { "Original file name" }
    var schema: any OpenAPISchemaRepresentable {
        MediaAssetHeaderValueField()
    }
}

struct MediaAssetExtensionHeader: HeaderParameterRepresentable {
    var name: String { "X-Media-Asset-Extension" }
    var description: String? { "Canonical file extension" }
    var schema: any OpenAPISchemaRepresentable {
        MediaAssetHeaderValueField()
    }
}

struct MediaAssetTitleHeader: HeaderParameterRepresentable {
    var name: String { "X-Media-Asset-Title" }
    var required: Bool { false }
    var description: String? { "Optional asset title" }
    var schema: any OpenAPISchemaRepresentable {
        MediaAssetHeaderValueField()
    }
}

struct MediaAssetAltTextHeader: HeaderParameterRepresentable {
    var name: String { "X-Media-Asset-Alt-Text" }
    var required: Bool { false }
    var description: String? { "Optional alternative text" }
    var schema: any OpenAPISchemaRepresentable {
        MediaAssetHeaderValueField()
    }
}

struct MediaAssetIdParameter: PathParameterRepresentable {
    var name: String { "mediaAssetId" }
    var description: String? { "MediaAsset id" }
    var schema: any OpenAPISchemaRepresentable {
        MediaAssetIdField().reference()
    }
}
