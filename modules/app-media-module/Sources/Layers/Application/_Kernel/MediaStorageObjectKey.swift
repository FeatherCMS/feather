public enum MediaStorageObjectKey {
    public static func original(
        assetID: String,
        fileExtension: String
    ) -> String {
        "\(assetID)/original.\(fileExtension)"
    }

    public static func variant(
        assetID: String,
        variantKey: String,
        fileExtension: String
    ) -> String {
        "\(assetID)/variants/\(variantKey).\(fileExtension)"
    }
}
