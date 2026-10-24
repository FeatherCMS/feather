import MediaModule

extension Variant.Processor.List {
    enum Error: Swift.Error, Sendable {
        case notFound
        case unauthorized
        case forbidden
        case unavailable
    }
}
