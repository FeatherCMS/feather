import OpenAPIRuntime
import HTTPTypes
import Hummingbird
import Application
import UserApplication
import Domain

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

struct AuthRenewMiddleware: ServerMiddleware {

    //    private static let sessionLifetime: Double = 604_800  // 1 week

    let modules: AppModules

    func intercept(
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
        return try await next(request, body, metadata)
    }
}
