public import struct Foundation.Date
public import Jobs

public extension JobQueueProtocol {
    func push<Parameters: JobParameters>(
        _ parameters: Parameters,
        scheduledAt: Date?
    ) async throws {
        _ = try await push(
            parameters,
            options: .init(delayUntil: scheduledAt ?? .now)
        )
    }
}
