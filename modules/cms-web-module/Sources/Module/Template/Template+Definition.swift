extension Template {
    public struct Definition: Sendable, Equatable {
        public let id: String
        public let title: String
        public let path: String
        public let fields: [Field]

        public init(
            id: String,
            title: String,
            path: String,
            fields: [Field] = []
        ) {
            self.id = id
            self.title = title
            self.path = path
            self.fields = fields
        }
    }
}
