public import FeatherApplication
public import SystemModule

extension Variable.Add {
    public struct Input: DTO {
        public let key: String
        public let value: String
        public let name: String?
        public let notes: String?

        public init(key: String, value: String, name: String?, notes: String?) {
            self.key = key
            self.value = value
            self.name = name
            self.notes = notes
        }
    }
}
