import AuthModule
public import FeatherBackend

protocol AuthUseCaseHTTPError: ErrorTraceRepresentable, HTTPErrorRepresentable {
    var logMessage: String { get }
    var message: String { get }
}

extension AuthUseCaseHTTPError {
    public var underlyingErrors: [any Error] { [] }

    public func trace() -> ErrorTrace {
        .init(
            type: Self.self,
            logMessage: logMessage,
            children: []
        )
    }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: message,
            reason: logMessage
        )
    }
}
