import FeatherOpenAPI

struct MediaAssetDetailResponse: JSONResponseRepresentable {
    var description: String = "MediaAsset response"
    var schema: some SchemaRepresentable {
        MediaAssetDetailSchema().reference()
    }
}

struct MediaAssetVariantListResponse: JSONResponseRepresentable {
    var description: String = "MediaAsset variant list response"
    var schema: some SchemaRepresentable {
        MediaAssetVariantListSchema().reference()
    }
}

struct MediaAssetResolveResponse: JSONResponseRepresentable {
    var description: String = "MediaAsset resolve response"
    var schema: some SchemaRepresentable {
        MediaAssetResolveSchema().reference()
    }
}
