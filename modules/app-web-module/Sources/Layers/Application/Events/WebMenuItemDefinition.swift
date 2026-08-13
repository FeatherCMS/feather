import FeatherContracts

public struct WebMenuItemDefinition: Sendable, Hashable, Codable {
    public let label: String
    public let url: String
    public let priority: Int
    public let isBlank: Bool
    public let permission: String
    public let authentication: WebMenuItemAuthentication
    public let notes: String

    public init(
        label: String,
        url: String,
        priority: Int,
        isBlank: Bool = false,
        permission: String = "",
        authentication: WebMenuItemAuthentication = .any,
        notes: String = ""
    ) {
        self.label = label
        self.url = url
        self.priority = priority
        self.isBlank = isBlank
        self.permission = permission
        self.authentication = authentication
        self.notes = notes
    }
}
