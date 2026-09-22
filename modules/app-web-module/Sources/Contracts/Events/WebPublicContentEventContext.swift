import FeatherContracts

public struct WebPublicContentEventContext: Sendable, Codable, ExecutionContext
{
    public let path: String
    public let templateIdentifier: String?
    public let referenceID: String?
    public let sessionToken: String?

    public init(
        path: String,
        templateIdentifier: String?,
        referenceID: String? = nil,
        sessionToken: String?
    ) {
        self.path = path
        self.templateIdentifier = templateIdentifier
        self.referenceID = referenceID
        self.sessionToken = sessionToken
    }
}
