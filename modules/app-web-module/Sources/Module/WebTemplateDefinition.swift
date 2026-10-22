public struct WebTemplateDefinition: Sendable, Equatable {

    public let id: String
    public let title: String
    public let path: String

    public init(
        id: String,
        title: String,
        path: String
    ) {
        self.id = id
        self.title = title
        self.path = path
    }
}
