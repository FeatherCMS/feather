public struct HierarchicalObjectKeyGenerator: ObjectKeyGenerator, Equatable {
    public let depth: Int
    public let segmentLength: Int

    public init(
        depth: Int = 0,
        segmentLength: Int = 2
    ) {
        self.depth = max(0, depth)
        self.segmentLength = max(1, segmentLength)
    }

    public var isEnabled: Bool {
        depth > 0
    }

    public func generate(from value: String) throws -> String {
        guard !value.isEmpty else {
            throw ObjectKeyGeneratorError.emptyValue
        }
        guard isEnabled else { return value }

        let characters = Array(value)
        let requiredLength = depth * segmentLength
        guard characters.count > requiredLength else { return value }

        var segments: [String] = []
        for index in 0..<depth {
            let start = index * segmentLength
            segments.append(String(characters[start..<(start + segmentLength)]))
        }
        segments.append(String(characters[requiredLength...]))
        return segments.joined(separator: "/")
    }
}
