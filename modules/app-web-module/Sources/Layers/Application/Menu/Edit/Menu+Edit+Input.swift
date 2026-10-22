public import FeatherApplication
public import WebDomain

extension Menu.Edit {
    public struct Input: DTO {
        public let id: String
        public let key: String?
        public let name: String?
        public let notes: String?

        public init(id: String, key: String?, name: String?, notes: String?) {
            self.id = id
            self.key = key
            self.name = name
            self.notes = notes
        }
    }
}
