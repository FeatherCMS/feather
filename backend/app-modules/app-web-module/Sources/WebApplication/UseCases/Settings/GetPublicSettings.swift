import Application

public struct GetPublicSettings {
    let query: any QueryExecutor<ReadSettings>

    public init(
        query: any QueryExecutor<ReadSettings>
    ) {
        self.query = query
    }

    public func execute() async throws -> SettingsDetail {
        try await query.run { context in
            try await context.settings.get()
        }
    }
}
