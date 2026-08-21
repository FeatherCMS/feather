import FeatherContracts
import Foundation

public struct WebPublicContentEventContext: Sendable, Codable, ExecutionContext
{
    public let path: String
    public let templateIdentifier: String?
    public let sessionToken: String?
    public let referenceType: String
    public let referenceID: String

    public init(
        path: String,
        templateIdentifier: String?,
        sessionToken: String?,
        referenceType: String = "",
        referenceID: String = ""
    ) {
        self.path = path
        self.templateIdentifier = templateIdentifier
        self.sessionToken = sessionToken
        self.referenceType = referenceType
        self.referenceID = referenceID
    }
}
