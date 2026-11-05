public import FeatherOpenAPI

public struct NoContentResponse: ResponseRepresentable {
    public let description: String
    public var contentMap: ContentMap { [:] }

    public init(description: String) {
        self.description = description
    }
}
