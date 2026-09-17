public struct MediaStorageShardConfiguration: Sendable, Equatable {
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
}
