public import FeatherApplication
public import FeatherStorage
public import Foundation
public import MediaModule
import NIOCore

extension Asset.File.Add {
    public struct Input: DTO {
        public let folderId: String?
        public let fileName: String
        public let `extension`: String
        public let title: String?
        public let altText: String?
        public let content: StorageSequence
        public let contentLength: Int64

        public init(
            folderId: String? = nil,
            fileName: String,
            `extension`: String,
            title: String? = nil,
            altText: String? = nil,
            content: StorageSequence,
            contentLength: Int64
        ) {
            self.folderId = folderId
            self.fileName = fileName
            self.extension = `extension`
            self.title = title
            self.altText = altText
            self.content = content
            self.contentLength = contentLength
        }

        public init(
            folderId: String? = nil,
            fileName: String,
            `extension`: String,
            title: String? = nil,
            altText: String? = nil,
            data: Data
        ) {
            var buffer = ByteBufferAllocator().buffer(capacity: data.count)
            buffer.writeBytes(data)
            self.init(
                folderId: folderId,
                fileName: fileName,
                extension: `extension`,
                title: title,
                altText: altText,
                content: .init(buffer: buffer),
                contentLength: Int64(data.count)
            )
        }
    }
}
