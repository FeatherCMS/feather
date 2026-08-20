public enum StatusCode: Int, Codable, CaseIterable, Sendable {
    case movedPermanently = 301
    case found = 302
    case temporaryRedirect = 307
    case permanentRedirect = 308
}