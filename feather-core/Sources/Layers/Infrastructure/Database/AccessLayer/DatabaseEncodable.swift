public protocol DatabaseEncodable: Sendable {
    func encode(to encoder: inout DatabaseFieldEncoder)
}
