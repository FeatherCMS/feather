import FeatherApplication
import FeatherBackend
import FeatherContracts
import FeatherDomain
import HTTPTypes
import Hummingbird
import OpenAPIRuntime
import UserApplication

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

public struct AuthRenewMiddleware: ServerMiddleware {

    //    private static let sessionLifetime: Double = 604_800  // 1 week

    let auth: AuthBackend.UseCases

    public init(auth: AuthBackend.UseCases) {
        self.auth = auth
    }

    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        metadata: ServerRequestMetadata,
        operationID: String,
        next: MiddlewareNextBlock
    ) async throws -> (HTTPResponse, HTTPBody?) {
        //        if let acl = try await AccessControl.get(ACL.self) {
        //            guard acl.userInfo["isPersistent"] == "true" else {
        //                return try await next(request, body, metadata)
        //            }
        //            guard let sessionToken = acl.userInfo["sessionToken"],
        //                !sessionToken.isEmpty
        //            else {
        //                return try await next(request, body, metadata)
        //            }
        //            let userSessionSlideExpirationUseCase = useCases.user.auth
        //                .slideSessionExpiration()
        //            _ = try await userSessionSlideExpirationUseCase.execute(
        //                .init(
        //                    token: sessionToken,
        //                    expiresAt: Date().timeIntervalSince1970
        //                        + Self.sessionLifetime
        //                )
        //            )
        //        }
        try await next(request, body, metadata)
    }
}
