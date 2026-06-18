public enum Search {

    public struct Page: Sendable {
        public var size: Int
        public var number: Int

        public init(size: Int = 20, number: Int = 1) {
            self.size = size
            self.number = number
        }
    }

    public enum SortDirection: String, Sendable, CaseIterable {
        case asc
        case desc
    }
}
