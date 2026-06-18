public protocol Clock: Sendable {
    func now() -> Double
}
