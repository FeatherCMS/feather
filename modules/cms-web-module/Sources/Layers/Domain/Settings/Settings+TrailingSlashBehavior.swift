public import WebModule

extension Settings {
    public enum TrailingSlashBehavior: String, Equatable, Sendable {
        case enforce
        case disable
    }
}
