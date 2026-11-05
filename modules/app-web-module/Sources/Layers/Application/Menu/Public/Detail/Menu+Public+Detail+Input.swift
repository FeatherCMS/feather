public import FeatherApplication
public import WebModule

extension Menu.Public.Detail {
    public struct Input: DTO {
        public let key: String

        public init(key: String) {
            self.key = key
        }
    }
}
