import Application

actor MockQueryExecutor<S: Scope>: QueryExecutor {
    private(set) var runCallCount = 0
    private let context: S

    init(context: S) {
        self.context = context
    }

    func run<T: Sendable>(
        _ body: @Sendable (S) async throws -> T
    ) async throws -> T {
        runCallCount += 1
        return try await body(context)
    }
}
