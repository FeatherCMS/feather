public import FeatherModuleKit

extension FeatherTesting.Authorizer {
    public actor Mock: FeatherModuleKit.Authorizer {
        public private(set) var canCallCount = 0

        private let result: Bool

        public init(result: Bool) {
            self.result = result
        }

        public func can(
            subject: Subject,
            perform action: any Action
        ) async throws -> Bool {
            canCallCount += 1
            return result
        }
    }
}
