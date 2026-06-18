import Application

public struct PublicMenuItem: DTO {
    public let id: String
    public let label: String
    public let url: String
    public let priority: Int
    public let isBlank: Bool

    public init(
        id: String,
        label: String,
        url: String,
        priority: Int,
        isBlank: Bool
    ) {
        self.id = id
        self.label = label
        self.url = url
        self.priority = priority
        self.isBlank = isBlank
    }
}
