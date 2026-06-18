import Application

public struct GetPublicRuleBySource {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let query: any QueryExecutor<ReadRule>

    public init(
        query: any QueryExecutor<ReadRule>
    ) {
        self.query = query
    }

    public func execute(
        source: String
    ) async throws -> PublicRedirectRule {
        try await query.run { context in
            guard let rule = try await context.rule.find(source: source) else {
                throw Error(message: "Redirect rule not found")
            }
            return .init(
                source: rule.source,
                destination: rule.destination,
                statusCode: rule.statusCode
            )
        }
    }
}
