public import FeatherApplication
public import UserModule

extension Role.Edit {
    public struct Input: DTO {
        public let id: String
        public let name: String?
        public let notes: String?

        public init(id: String, name: String?, notes: String?) {
            self.id = id
            self.name = name
            self.notes = notes
        }
    }
}
