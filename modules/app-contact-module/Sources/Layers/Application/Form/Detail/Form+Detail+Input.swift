public import ContactModule
public import FeatherApplication

extension Form.Detail {
    public struct Input: DTO {
        public let key: String

        public init(key: String) {
            self.key = key
        }
    }
}
