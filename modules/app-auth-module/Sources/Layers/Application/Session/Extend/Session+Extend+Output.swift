public import AuthModule
public import FeatherApplication

extension Session.Extend {
    public struct Output: DTO {
        public let didExtend: Bool

        public init(didExtend: Bool) {
            self.didExtend = didExtend
        }
    }
}
