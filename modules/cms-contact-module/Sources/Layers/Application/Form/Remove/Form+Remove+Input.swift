public import ContactModule
public import FeatherApplication

extension Form.Remove {
    public struct Input: DTO {
        public let keys: [String]

        public init(keys: [String]) {
            self.keys = keys
        }
    }
}
