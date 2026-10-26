public import FeatherDomain

extension FeatherTesting.IDGenerator {
    public struct Mock: FeatherDomain.IDGenerator {
        public let id: String

        public init(id: String) {
            self.id = id
        }

        public func generate() -> String {
            id
        }
    }
}
