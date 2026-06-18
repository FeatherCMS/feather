public struct MediaCommandResult: Sendable {
    public let exitCode: Int32
    public let standardOutput: String?
    public let standardError: String?

    public init(
        exitCode: Int32,
        standardOutput: String?,
        standardError: String?
    ) {
        self.exitCode = exitCode
        self.standardOutput = standardOutput
        self.standardError = standardError
    }
}

public protocol MediaShellRunner: Sendable {
    func run(
        command: String
    ) async throws -> MediaCommandResult
}
