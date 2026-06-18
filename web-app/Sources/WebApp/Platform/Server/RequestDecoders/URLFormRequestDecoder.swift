//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 01..
//

import Foundation
import Hummingbird

struct URLFormRequestDecoder: RequestDecoder {
    let decoder = URLEncodedFormDecoder()

    func decode<T>(
        _ type: T.Type,
        from request: Request,
        context: some RequestContext
    ) async throws -> T where T: Decodable {
        if isURLEncodedFormContentType(request.headers[.contentType]) {
            var buffer = ByteBuffer()
            try await request.body.collect(upTo: Int.max, into: &buffer)
            let raw =
                buffer.getString(at: 0, length: buffer.readableBytes) ?? ""
            let normalized = normalizeArrayKeySuffixes(in: raw)
            return try self.decoder.decode(type, from: normalized)
        }
        throw HTTPError(.unsupportedMediaType)
    }

    private func normalizeArrayKeySuffixes(
        in raw: String
    ) -> String {
        guard !raw.isEmpty else { return raw }

        let pairs: [(decodedKey: String, rawValue: String, hasValue: Bool)] =
            raw
            .split(separator: "&")
            .map { pair in
                let parts = pair.split(
                    separator: "=",
                    maxSplits: 1,
                    omittingEmptySubsequences: false
                )
                let keyRaw = String(parts.first ?? "")
                let valueRaw = parts.count > 1 ? String(parts[1]) : ""
                return (
                    decodedKey: decodeFormComponent(keyRaw),
                    rawValue: valueRaw,
                    hasValue: parts.count > 1
                )
            }

        var countsByBaseKey: [String: Int] = [:]
        for pair in pairs {
            let baseKey =
                pair.decodedKey.hasSuffix("[]")
                ? String(pair.decodedKey.dropLast(2))
                : pair.decodedKey
            countsByBaseKey[baseKey, default: 0] += 1
        }

        let normalizedPairs: [String] = pairs.map { pair in
            let hadArraySuffix = pair.decodedKey.hasSuffix("[]")
            let baseKey =
                pair.decodedKey.hasSuffix("[]")
                ? String(pair.decodedKey.dropLast(2))
                : pair.decodedKey
            let shouldBeArray =
                hadArraySuffix || (countsByBaseKey[baseKey] ?? 0) > 1
            let normalizedDecodedKey = shouldBeArray ? "\(baseKey)[]" : baseKey
            let encodedKey = encodeFormComponent(normalizedDecodedKey)

            if pair.hasValue {
                return "\(encodedKey)=\(pair.rawValue)"
            }
            return encodedKey
        }

        return normalizedPairs.joined(separator: "&")
    }

    private func decodeFormComponent(
        _ value: String
    ) -> String {
        let plusDecoded = value.replacingOccurrences(of: "+", with: " ")
        return plusDecoded.removingPercentEncoding ?? plusDecoded
    }

    private func encodeFormComponent(
        _ value: String
    ) -> String {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "&=+")
        return value.addingPercentEncoding(withAllowedCharacters: allowed)
            ?? value
    }

    private func isURLEncodedFormContentType(
        _ value: String?
    ) -> Bool {
        guard let value else {
            return false
        }
        let mediaType =
            value
            .split(
                separator: ";",
                maxSplits: 1,
                omittingEmptySubsequences: true
            )
            .first?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        return mediaType == "application/x-www-form-urlencoded"
    }
}
