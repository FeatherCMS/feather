import Hummingbird

extension Request {
    func queryInt(
        _ key: String
    ) -> Int? {
        guard let query = uri.query, !query.isEmpty else { return nil }
        for pair in query.split(separator: "&", omittingEmptySubsequences: true)
        {
            let parts = pair.split(
                separator: "=",
                maxSplits: 1,
                omittingEmptySubsequences: false
            )
            guard let rawKey = parts.first, rawKey == Substring(key) else {
                continue
            }
            guard parts.count == 2 else { return nil }
            return Int(parts[1])
        }
        return nil
    }

    func queryPage(
        default defaultValue: Int = 1
    ) -> Int {
        max(1, queryInt("page") ?? defaultValue)
    }
}
