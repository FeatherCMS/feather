extension Menu {
    public struct Definition: Sendable, Equatable {
        public let key: String
        public let name: String
        public let notes: String?

        public init(
            key: String,
            name: String,
            notes: String? = nil
        ) {
            self.key = key
            self.name = name
            self.notes = notes
        }
    }
}
