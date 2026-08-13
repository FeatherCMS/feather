public protocol ContextualExecutor<S, C>: Executor where S: Scope {
    associatedtype C

    func run<T: Sendable>(
        _ body: @Sendable (S, C) async throws -> T
    ) async throws -> T
}
