public import SystemModule
public import FeatherApplication

extension Variable.Edit {
    public struct Output: DTO, Sendable {
        public let id: String
        public let key: String
        public let value: String
        public let name: String?
        public let notes: String?

        package init(
            id: String,
            key: String,
            value: String,
            name: String?,
            notes: String?
        ) {
            self.id = id
            self.key = key
            self.value = value
            self.name = name
            self.notes = notes
        }
    }
}
