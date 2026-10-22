public enum MenuItem {
    public enum Authentication: String, Sendable, Codable, CaseIterable {
        case any
        case anonymous
        case authenticated
    }
}
