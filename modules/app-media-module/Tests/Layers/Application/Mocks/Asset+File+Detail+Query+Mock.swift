import MediaModule

@testable import MediaApplication

extension Asset.File.Detail.Query {
    actor Mock: Interface {
        private(set) var findCallCount = 0
        private let result: Asset.File.Detail.Output

        init(result: Asset.File.Detail.Output) {
            self.result = result
        }

        func find(id: String) async throws -> Asset.File.Detail.Output {
            findCallCount += 1
            return result
        }
    }
}
