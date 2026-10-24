public import AuthModule

extension Email.Remove {
    public struct Output: Sendable {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
