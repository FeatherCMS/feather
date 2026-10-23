import FeatherBackend
import Foundation

struct DecodingErrorAdapter: Error, ErrorTraceRepresentable {
    let error: DecodingError

    var underlyingErrors: [any Error] {
        switch error {
        case .typeMismatch(_, let context),
            .valueNotFound(_, let context),
            .keyNotFound(_, let context),
            .dataCorrupted(let context):
            context.underlyingError.map { [$0] } ?? []
        @unknown default:
            []
        }
    }

    func trace() -> ErrorTrace {
        let logMessage: String
        switch error {
        case .typeMismatch(let type, _):
            logMessage = "Type mismatch (\(type))"
        case .valueNotFound(let type, _):
            logMessage = "Value not found (\(type))"
        case .keyNotFound(let key, _):
            logMessage = "Key not found (\(key.stringValue))"
        case .dataCorrupted:
            logMessage = "Data corrupted"
        @unknown default:
            logMessage = "Unknown decoding error"
        }
        return BackendErrorAdapter.trace(
            for: error,
            logMessage: logMessage,
            underlyingErrors: underlyingErrors
        )
    }
}
