extension MenuItem {
    public struct Definition: Sendable, Equatable {
        public enum Authentication: String, Sendable {
            case any
            case anonymous
            case authenticated
        }

        public let label: String
        public let url: String
        public let priority: Int
        public let isBlank: Bool
        public let permission: String
        public let authentication: Authentication
        public let notes: String?

        public init(
            label: String,
            url: String,
            priority: Int,
            isBlank: Bool = false,
            permission: String = "",
            authentication: Authentication = .any,
            notes: String? = nil
        ) {
            self.label = label
            self.url = url
            self.priority = priority
            self.isBlank = isBlank
            self.permission = permission
            self.authentication = authentication
            self.notes = notes
        }
    }
}
