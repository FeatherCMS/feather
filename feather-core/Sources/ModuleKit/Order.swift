public enum Order: String, Sendable & Equatable & Hashable & Codable,
    CaseIterable
{
    case asc
    case desc
}
