extension Page.Metadata {
    public enum Status: String, Sendable, CaseIterable {
        case draft
        case published
        case archived
    }
}
