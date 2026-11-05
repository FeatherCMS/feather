public import AuthModule
public import FeatherApplication

extension MagicLink.Remove {
    public struct Output: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
