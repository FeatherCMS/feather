import FeatherDatabase

public protocol DatabaseDecodable: Sendable {
    init(from decoder: DatabaseRowDecoder, row: any DatabaseRow) throws
}
