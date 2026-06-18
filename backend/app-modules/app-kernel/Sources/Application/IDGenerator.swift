public protocol IDGenerator: Sendable {
    func generate() -> String
}
