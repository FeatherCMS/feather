import NIOHTTP1
import HTTPTypes
import OpenAPIRuntime
import PostgresNIO

extension PSQLError: HTTPErrorRepresentable {

    private var sqlState: String? {
        serverInfo?[.sqlState]
    }

    var status: HTTPResponseStatus {
        switch sqlState {
        case "23505":
            return .conflict
        case "23502", "23503":
            return .badRequest
        default:
            return .internalServerError
        }
    }

    var content: ServerError.Details? {
        switch sqlState {
        case "23505":
            return .init(
                code: .conflict,
                message: "Duplicate value.",
                reason: serverInfo?[.message] ?? description
            )
        case "23502":
            return .init(
                code: .badRequest,
                message: "Missing required value.",
                reason: serverInfo?[.message] ?? description
            )
        case "23503":
            return .init(
                code: .badRequest,
                message: "Invalid reference.",
                reason: serverInfo?[.message] ?? description
            )
        default:
            return .init(
                code: .internalServerError,
                message: "Internal server error.",
                reason: serverInfo?[.message] ?? description
            )
        }
    }
}
