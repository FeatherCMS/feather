import Application

public struct PublicRedirectRule: DTO {
    public let source: String
    public let destination: String
    public let statusCode: Int

    public init(
        source: String,
        destination: String,
        statusCode: Int
    ) {
        self.source = source
        self.destination = destination
        self.statusCode = statusCode
    }
}
