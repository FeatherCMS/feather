import AppOpenAPI
import FeatherDatabase
import WebApplication

private extension Error {
    var isResolveWebRouteNotFound: Bool {
        if self is ResolveWebRoute.Error {
            return true
        }
        if let databaseError = self as? DatabaseError {
            return databaseError.isResolveWebRouteNotFound
        }
        if let transactionError = self as? any DatabaseTransactionError {
            return transactionError.closureError?.isResolveWebRouteNotFound
                ?? false
        }
        return false
    }
}

private extension DatabaseError {
    var isResolveWebRouteNotFound: Bool {
        switch self {
        case .connection(let error):
            return error.isResolveWebRouteNotFound
        case .query(let error):
            return error.isResolveWebRouteNotFound
        case .transaction(let error):
            return error.closureError?.isResolveWebRouteNotFound ?? false
        }
    }
}

extension AppAPI {
    func webMetadataGet(
        _ input: Operations.WebMetadataGet.Input
    ) async throws -> Operations.WebMetadataGet.Output {
        do {
            let route = try await modules.web.makeResolveWebRoute()
                .execute(
                    slug: input.path.slug
                )
            return .ok(
                .init(
                    body: .json(
                        .init(
                            referenceType: route.referenceType,
                            referenceId: route.referenceID,
                            slug: route.slug
                        )
                    )
                )
            )
        }
        catch is ResolveWebRoute.Error {
            return .notFound
        }
        catch let error as DatabaseError
        where error.isResolveWebRouteNotFound {
            return .notFound
        }
    }
}
