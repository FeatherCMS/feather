import Hummingbird

enum QueryFlag {
    static func isSet(
        _ key: String,
        in query: String?
    ) -> Bool {
        guard let query, !query.isEmpty else { return false }
        for pair in query.split(separator: "&", omittingEmptySubsequences: true)
        {
            let parts = pair.split(
                separator: "=",
                maxSplits: 1,
                omittingEmptySubsequences: false
            )
            guard let rawKey = parts.first else { continue }
            if rawKey == Substring(key) {
                if parts.count == 1 { return true }
                if parts[1] == "1" { return true }
            }
        }
        return false
    }
}

extension Request {
    func hasQueryFlag(
        _ key: String
    ) -> Bool {
        QueryFlag.isSet(key, in: uri.query)
    }
}
