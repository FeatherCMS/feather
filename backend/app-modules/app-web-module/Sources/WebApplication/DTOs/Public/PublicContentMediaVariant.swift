import Application

public struct PublicContentMediaVariant: DTO {
    public let id: String
    public let url: String
    public let type: String
    public let width: Int?
    public let height: Int?

    public init(
        id: String,
        url: String,
        type: String,
        width: Int?,
        height: Int?
    ) {
        self.id = id
        self.url = url
        self.type = type
        self.width = width
        self.height = height
    }
}
