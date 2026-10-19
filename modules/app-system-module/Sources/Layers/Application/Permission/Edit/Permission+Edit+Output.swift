public import SystemModule
public import FeatherApplication

extension Permission.Edit {
    public struct Output: FeatherApplication.DTO {
        public let id: String
        public let key: String
        public let name: String?
        public let notes: String?

        package init(
            id: String,
            key: String,
            name: String?,
            notes: String?
        ) {
            self.id = id
            self.key = key
            self.name = name
            self.notes = notes
        }
    }
}
