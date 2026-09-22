
public struct MediaStorageKeyShard: Sendable, Equatable {
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

    public func physicalKey(for key: String) -> String {
        guard isEnabled else { return key }

        let components =
            key
            .split(separator: "/", omittingEmptySubsequences: true)
            .map(String.init)
        guard let assetsIndex = components.firstIndex(of: "assets"),
            assetsIndex + 1 < components.count
        else { return key }

        let assetID = components[assetsIndex + 1]
        let characters = Array(assetID)
        let requiredLength = depth * segmentLength
        guard characters.count > requiredLength else { return key }

        var segments = Array(components[..<assetsIndex])
        for index in 0..<depth {
            let start = index * segmentLength
            let end = start + segmentLength
            segments.append(String(characters[start..<end]))
        }
        segments.append(String(characters[requiredLength...]))
        segments.append(contentsOf: components[(assetsIndex + 2)...])
        return segments.joined(separator: "/")
    }
}
