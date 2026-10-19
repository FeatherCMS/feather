public import FeatherModuleKit

extension FeatherTesting.QueryExecutor {
    public actor Mock<S: Scope>: FeatherModuleKit.QueryExecutor {
        public private(set) var runCallCount = 0

        private let context: S
        private let error: (any Error)?

        public init(context: S, error: (any Error)? = nil) {
            self.context = context
            self.error = error
        }

        public func run<T: Sendable>(
            _ body: @Sendable (S) async throws -> T
        ) async throws -> T {
            runCallCount += 1
            if let error {
                throw error
            }
            return try await body(context)
        }
    }
}
