public protocol Executor<S>: Sendable {

    associatedtype S: Scope

    func run<T: Sendable>(
        _ body: @Sendable (S) async throws -> T
    ) async throws -> T
}
