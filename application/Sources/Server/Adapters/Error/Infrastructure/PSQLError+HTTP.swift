public import FeatherBackend
public import NIOHTTP1
public import PostgresNIO

extension PSQLError: @retroactive HTTPErrorRepresentable {

    private var sqlState: String? {
        serverInfo?[.sqlState]
    }

    public var status: HTTPResponseStatus {
        switch sqlState {
        case "23505":
            return .conflict
        case "23502", "23503":
            return .badRequest
        default:
            return .internalServerError
        }
    }

    private var errorMessage: String {
        switch sqlState {
        case "23505":
            return "Duplicate value."
        case "23502":
            return "Missing required value."
        case "23503":
            return "Invalid reference."
        default:
            return "Internal server error."
        }
    }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: errorMessage,
            reason: serverInfo?[.message] ?? description
        )
    }
}
