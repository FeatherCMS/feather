public import Jobs

public import struct Foundation.Date

extension JobQueueProtocol {
    public func push<Parameters: JobParameters>(
        _ parameters: Parameters,
        scheduledAt: Date?
    ) async throws {
        _ = try await push(
            parameters,
            options: .init(delayUntil: scheduledAt ?? .now)
        )
    }
}
