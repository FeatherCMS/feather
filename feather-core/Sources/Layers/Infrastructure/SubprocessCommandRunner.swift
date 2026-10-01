public import FeatherDomain
import Subprocess

#if canImport(System)
import System
#else
import SystemPackage
#endif

public struct SubprocessCommandRunner: CommandRunner {
    public init() {}

    public func run(command: String) async throws -> CommandResult {
        let result = try await Subprocess.run(
            .path("/bin/sh"),
            arguments: .init(["-lc", command]),
            output: .string(limit: 1_048_576),
            error: .string(limit: 1_048_576)
        )

        let exitCode: Int32
        switch result.terminationStatus {
        case .exited(let code):
            exitCode = code
        case .signaled(let signal):
            exitCode = -signal
        }

        return .init(
            exitCode: exitCode,
            standardOutput: result.standardOutput,
            standardError: result.standardError
        )
    }
}
