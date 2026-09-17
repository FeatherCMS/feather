public enum MediaStorageObjectKey {
    public static let assetNamespace = "/media/assets"

    public static func original(
        assetID: String,
        fileExtension: String
    ) -> String {
        "\(assetNamespace)/\(assetID)/original.\(fileExtension)"
    }

    public static func variant(
        assetID: String,
        variantKey: String,
        fileExtension: String
    ) -> String {
        "\(assetNamespace)/\(assetID)/variants/\(variantKey).\(fileExtension)"
    }
}
