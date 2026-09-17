//
//  MediaStorageClient.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherStorage
import Foundation
import MediaApplication
import NIOCore

public struct MediaStorageClient: MediaStorage {

    let client: any StorageClient
    let shardConfiguration: MediaStorageShardConfiguration

    public init(
        client: any StorageClient,
        shardConfiguration: MediaStorageShardConfiguration = .init()
    ) {
        self.client = client
        self.shardConfiguration = shardConfiguration
    }

    public func download(
        key: String
    ) async throws -> Data {
        try await downloadData(key: physicalKey(for: key))
    }

    public func upload(
        key: String,
        data: Data
    ) async throws {
        var buffer = ByteBufferAllocator().buffer(capacity: data.count)
        buffer.writeBytes(data)
        try await client.upload(
            key: physicalKey(for: key),
            sequence: .init(buffer: buffer)
        )
    }

    public func delete(
        key: String
    ) async throws {
        try await client.delete(key: physicalKey(for: key))
    }
}

extension MediaStorageClient {
    private func downloadData(
        key: String
    ) async throws -> Data {
        let sequence = try await client.download(key: key, range: nil)
        var data = Data()
        for try await buffer in sequence {
            data.append(contentsOf: buffer.readableBytesView)
        }
        return data
    }

    private func physicalKey(
        for key: String
    ) -> String {
        guard shardConfiguration.isEnabled else { return key }

        let components = key.split(separator: "/", omittingEmptySubsequences: true).map(String.init)
        guard let assetsIndex = components.firstIndex(of: "assets"), assetsIndex + 1 < components.count else { return key }
        let assetID = components[assetsIndex + 1]
        let characters = Array(assetID)
        let requiredLength = shardConfiguration.depth * shardConfiguration.segmentLength
        guard characters.count > requiredLength else { return key }

        var segments = Array(components[..<assetsIndex])
        for index in 0..<shardConfiguration.depth {
            let start = index * shardConfiguration.segmentLength
            let end = start + shardConfiguration.segmentLength
            segments.append(String(characters[start..<end]))
        }
        segments.append(String(characters[requiredLength...]))
        segments.append(contentsOf: components[(assetsIndex + 2)...])
        return segments.joined(separator: "/")
    }
}
