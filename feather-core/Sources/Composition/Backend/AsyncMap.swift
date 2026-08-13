extension Collection {
    public func asyncMap<T: Sendable>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var result: [T] = []
        result.reserveCapacity(count)
        for element in self {
            result.append(try await transform(element))
        }
        return result
    }
}
