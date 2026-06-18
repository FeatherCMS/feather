import Foundation
import Hummingbird

extension Request {
    func queryString(
        _ key: String
    ) -> String? {
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
            return String(parts[1]).removingPercentEncoding ?? String(parts[1])
        }
        return nil
    }

    func queryStrings(
        _ key: String
    ) -> [String] {
        guard let query = uri.query, !query.isEmpty else { return [] }
        var values: [String] = []
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
            guard parts.count == 2 else { continue }
            let rawValue = String(parts[1])
            values.append(rawValue.removingPercentEncoding ?? rawValue)
        }
        return values
    }

    func querySearch() -> String? {
        guard
            let raw = queryString("search")?
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                ),
            !raw.isEmpty
        else { return nil }
        return raw
    }
}

extension String {
    func queryEncoded() -> String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
