import FeatherBackend
import FeatherDatabase
import FeatherDatabasePostgres
import FeatherInfrastructure
import NIOHTTP1
import OpenAPIRuntime
import PostgresNIO
import AccountBackend
import AuthBackend
import RedirectBackend
import SystemBackend
import UserBackend

enum BackendErrorAdapter {

    static func adapt(_ error: any Error) -> any Error {
        if let error = error as? QueryError {
            return QueryErrorAdapter(error: error)
        }
        if let error = error as? RepositoryError {
            return RepositoryErrorAdapter(error: error)
        }
        if let error = error as? DecodingError {
            return DecodingErrorAdapter(error: error)
        }
        if let error = error as? ServerError {
            return ServerErrorAdapter(error: error)
        }
        if let error = error as? DatabaseError {
            return DatabaseErrorAdapter(error: error)
        }
        if let error = error as? DatabaseTransactionErrorPostgres {
            return DatabaseTransactionErrorAdapter(error: error)
        }
        if let error = error as? PSQLError {
            return PostgresErrorAdapter(error: error)
        }
        if let accountError = AccountBackend.ErrorAdapter.adapt(error) {
            return accountError
        }
        if let authError = AuthBackend.ErrorAdapter.adapt(error) {
            return authError
        }
        if let systemError = SystemBackend.ErrorAdapter.adapt(error) {
            return systemError
        }
        if let userError = UserBackend.ErrorAdapter.adapt(error) {
            return userError
        }
        if let redirectError = RedirectBackend.ErrorAdapter.adapt(error) {
            return redirectError
        }
        return error
    }

    static func trace(
        for error: any Error,
        logMessage: String,
        underlyingErrors: [any Error]
    ) -> ErrorTrace {
        .init(
            type: type(of: error),
            logMessage: logMessage,
            children: underlyingErrors.map { error in
                let adaptedError = adapt(error)
                if let traceableError = adaptedError
                    as? any ErrorTraceRepresentable
                {
                    return traceableError.trace()
                }
                return ErrorTrace(
                    type: type(of: error),
                    logMessage: String(describing: error),
                    children: []
                )
            }
        )
    }
}

private struct DatabaseErrorAdapter: Error, ErrorTraceRepresentable {
    let error: DatabaseError

    var underlyingErrors: [any Error] {
        switch error {
        case .connection(let error):
            [BackendErrorAdapter.adapt(error)]
        case .transaction(let error):
            [BackendErrorAdapter.adapt(error)]
        case .query(let error):
            [BackendErrorAdapter.adapt(error)]
        }
    }

    func trace() -> ErrorTrace {
        let logMessage: String
        switch error {
        case .connection:
            logMessage = "Connection"
        case .transaction:
            logMessage = "Transaction"
        case .query:
            logMessage = "Query"
        }
        return BackendErrorAdapter.trace(
            for: error,
            logMessage: logMessage,
            underlyingErrors: underlyingErrors
        )
    }
}

private struct DatabaseTransactionErrorAdapter: Error, ErrorTraceRepresentable {
    let error: DatabaseTransactionErrorPostgres

    var underlyingErrors: [any Error] {
        if let error = error.beginError {
            return [BackendErrorAdapter.adapt(error)]
        }
        if let error = error.closureError {
            return [BackendErrorAdapter.adapt(error)]
        }
        if let error = error.commitError {
            return [BackendErrorAdapter.adapt(error)]
        }
        if let error = error.rollbackError {
            return [BackendErrorAdapter.adapt(error)]
        }
        return []
    }

    func trace() -> ErrorTrace {
        let logMessage: String
        if error.beginError != nil {
            logMessage = "Begin"
        }
        else if error.closureError != nil {
            logMessage = "Closure"
        }
        else if error.commitError != nil {
            logMessage = "Commit"
        }
        else if error.rollbackError != nil {
            logMessage = "Rollback"
        }
        else {
            logMessage = "Unknown"
        }
        return BackendErrorAdapter.trace(
            for: error,
            logMessage: logMessage,
            underlyingErrors: underlyingErrors
        )
    }
}

private struct PostgresErrorAdapter: ErrorTraceRepresentable,
    HTTPErrorRepresentable
{
    let error: PSQLError

    var underlyingErrors: [any Error] {
        error.underlying.map { [BackendErrorAdapter.adapt($0)] } ?? []
    }

    func trace() -> ErrorTrace {
        BackendErrorAdapter.trace(
            for: error,
            logMessage: error.query?.sql ?? String(reflecting: error),
            underlyingErrors: underlyingErrors
        )
    }

    private var sqlState: String? {
        error.serverInfo?[.sqlState]
    }

    var status: HTTPResponseStatus {
        switch sqlState {
        case "23505": .conflict
        case "23502", "23503": .badRequest
        default: .internalServerError
        }
    }

    private var errorMessage: String {
        switch sqlState {
        case "23505": "Duplicate value."
        case "23502": "Missing required value."
        case "23503": "Invalid reference."
        default: "Internal server error."
        }
    }

    var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: errorMessage,
            reason: error.serverInfo?[.message] ?? error.description
        )
    }
}
