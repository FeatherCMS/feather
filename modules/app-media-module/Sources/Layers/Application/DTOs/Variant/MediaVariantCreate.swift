public import FeatherApplication

public struct MediaVariantCreate: DTO {
    public let key: String
    public let name: String
    public let isRequired: Bool
    public let isActive: Bool

    public init(key: String, name: String, isRequired: Bool, isActive: Bool) {
        self.key = key
        self.name = name
        self.isRequired = isRequired
        self.isActive = isActive
    }
}
