import FeatherOpenAPI

struct BlogTagIdField: StringSchemaRepresentable {
    var example: String? = "wp_home"
}

struct BlogTagContentField: StringSchemaRepresentable {
    var example: String? = "<h1>Homepage</h1>"
}

struct BlogTagExcerptField: StringSchemaRepresentable {
    var example: String? = "Short tag summary."
}

struct BlogTagTitleField: StringSchemaRepresentable {
    var example: String? = "Swift"
}

struct BlogTagImageAssetIdField: StringSchemaRepresentable {
    var example: String? = "media_asset_1"
}

struct BlogTagUpdateMaskField: StringSchemaRepresentable {
    var example: String? = "title,imageAssetId"
}

struct BlogTagCreatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}

struct BlogTagUpdatedAtField: DoubleSchemaRepresentable {
    var example: Double? { 1_760_000_000 }
}
