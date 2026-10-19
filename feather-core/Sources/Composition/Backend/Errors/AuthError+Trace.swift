public import FeatherModuleKit

extension AuthError: ErrorTraceRepresentable {
    public var underlyingErrors: [any Error] { [] }

    public func trace() -> ErrorTrace {
        .init(type: Self.self, logMessage: message, children: [])
    }
}
