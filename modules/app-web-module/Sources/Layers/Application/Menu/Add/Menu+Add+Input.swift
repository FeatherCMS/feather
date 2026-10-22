public import FeatherApplication
public import WebModule

extension Menu.Add {
    public struct Input: FeatherApplication.DTO {
        public let key: String
        public let name: String
        public let notes: String

        public init(key: String, name: String, notes: String) {
            self.key = key
            self.name = name
            self.notes = notes
        }
    }
}
