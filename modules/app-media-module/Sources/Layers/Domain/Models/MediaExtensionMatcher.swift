//
//  MediaExtensionMatcher.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Foundation

public enum MediaExtensionMatcher {
    public static func matches(
        asset: MediaAssetNodeFile,
        processor: MediaProcessor
    ) -> Bool {
        matches(
            extension: asset.extension,
            processor: processor
        )
    }

    public static func matches(
        `extension`: String,
        processor: MediaProcessor
    ) -> Bool {
        let assetExtension = canonicalExtension(from: `extension`) ?? "bin"

        let acceptedExtensions = processor.matchExtensions
            .components(separatedBy: CharacterSet(charactersIn: ",; \n\r\t"))
            .compactMap { canonicalExtension(from: String($0)) }
            .filter { !$0.isEmpty }

        return acceptedExtensions.contains(assetExtension)
    }

    public static func canonicalExtension(
        from value: String
    ) -> String? {
        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        guard !normalized.isEmpty else { return nil }

        let strippedPrefix =
            normalized.hasPrefix(".")
            ? String(normalized.drop(while: { $0 == "." }))
            : normalized
        let rawExtension =
            strippedPrefix.contains("/")
            ? (strippedPrefix.split(separator: "/").last.map(String.init)
                ?? strippedPrefix)
            : strippedPrefix

        switch rawExtension {
        case "jpg", "jpeg":
            return "jpeg"
        default:
            return rawExtension
        }
    }

}
