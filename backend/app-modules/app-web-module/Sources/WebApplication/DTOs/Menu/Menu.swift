import Application

public struct PublicMenu: DTO {
    public let id: String
    public let key: String
    public let name: String
    public let items: [PublicMenuItem]

    public init(
        id: String,
        key: String,
        name: String,
        items: [PublicMenuItem]
    ) {
        self.id = id
        self.key = key
        self.name = name
        self.items = items
    }
}
