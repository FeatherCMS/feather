import MediaApplication
import Subprocess

public struct SubprocessMediaShellRunner: MediaShellRunner {
    public init() {}

    public func run(
        command: String
    ) async throws -> MediaCommandResult {
        let result = try await execute(command: command)

        if let fallback = fallbackCommand(for: command, result: result) {
            return try await execute(command: fallback)
        }

        return result
    }
}

extension SubprocessMediaShellRunner {
    func fallbackCommand(
        for command: String,
        result: MediaCommandResult
    ) -> String? {
        guard command.hasPrefix("magick ") else {
            return nil
        }
        guard result.exitCode == 127 else {
            return nil
        }

        let standardError = result.standardError?.lowercased() ?? ""
        guard
            standardError.contains("magick")
                && standardError.contains("not found")
        else {
            return nil
        }

        return "convert " + command.dropFirst("magick ".count)
    }

    private func execute(
        command: String
    ) async throws -> MediaCommandResult {
        let result = try await Subprocess.run(
            .name("/bin/sh"),
            arguments: .init(["-lc", command]),
            output: .string(limit: 1024 * 1024),
            error: .string(limit: 1024 * 1024)
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
