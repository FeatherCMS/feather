public import AuthModule

extension Email.Remove {
    public struct Input: Sendable {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
