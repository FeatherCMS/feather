public import SystemModule
public import FeatherApplication

extension Permission.Add {
    public struct Input: FeatherApplication.DTO {
        public let key: String
        public let name: String?
        public let notes: String?

        public init(
            key: String,
            name: String?,
            notes: String?
        ) {
            self.key = key
            self.name = name
            self.notes = notes
        }
    }
}
