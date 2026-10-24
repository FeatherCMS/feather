import FeatherDatabase
import WebApplication
import WebModule

extension Error {
    var isResolveWebRouteNotFound: Bool {
        if self is WebRoute.Resolve.UseCase.Error {
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

extension DatabaseError {
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
