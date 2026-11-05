public import AuthModule
public import FeatherApplication

extension MagicLink.Request {
    public struct Output: DTO {
        public let didCreateRequest: Bool

        public init(didCreateRequest: Bool) {
            self.didCreateRequest = didCreateRequest
        }
    }
}
