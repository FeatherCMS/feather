public func mediaAssetPublicURL(
    id: String,
    slugPath: String,
    `extension`: String
) -> String {
    "/media/assets/\(id)/\(slugPath).\(`extension`)"
}

public func mediaVariantPublicURL(
    assetId: String,
    name: String,
    `extension`: String
) -> String {
    "/media/variants/\(assetId)/\(name).\(`extension`)"
}
