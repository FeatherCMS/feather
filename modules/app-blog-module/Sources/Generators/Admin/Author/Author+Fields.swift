import FeatherOpenAPI

struct BlogAuthorIdField: StringSchemaRepresentable {
    var example: String? = "wm_header"
}

struct BlogAuthorNameField: StringSchemaRepresentable {
    var example: String? = "Header menu"
}

struct BlogAuthorContentField: StringSchemaRepresentable {
    var example: String? = "Author biography."
}

struct BlogAuthorExcerptField: StringSchemaRepresentable {
    var example: String? = "Short author summary."
}

struct BlogAuthorProfileImageAssetIdField: StringSchemaRepresentable {
    var example: String? = "media_asset_1"
}

struct BlogAuthorUpdateMaskField: StringSchemaRepresentable {
    var example: String? = "name,excerpt"
}

struct BlogAuthorCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct BlogAuthorUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}
