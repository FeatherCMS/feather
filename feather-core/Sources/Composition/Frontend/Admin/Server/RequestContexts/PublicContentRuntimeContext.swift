public import FeatherContracts
public import Foundation
public import Hummingbird

public struct PublicContentRuntimeContext: Sendable {
    public let request: Request
    public let context: DefaultRequestContext
    public let apiBaseURL: URL
    public let publicOrigins: AppPublicOriginConfiguration
    public let mediaResolver: MediaResolver

    public init(
        request: Request,
        context: DefaultRequestContext,
        apiBaseURL: URL,
        publicOrigins: AppPublicOriginConfiguration,
        mediaResolver: MediaResolver
    ) {
        self.request = request
        self.context = context
        self.apiBaseURL = apiBaseURL
        self.publicOrigins = publicOrigins
        self.mediaResolver = mediaResolver
    }
}
