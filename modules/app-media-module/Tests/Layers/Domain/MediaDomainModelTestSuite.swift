import Foundation
import MediaModule
import Testing

@testable import MediaDomain

@Suite
struct MediaDomainModelTestSuite {
    @Test
    func mediaAssetCreateDefaultsToUploadedStatus() {
        let asset = Asset.File.Model.create(
            folderId: "folder-1",
            name: "hero",
            slug: "hero",
            slugPath: "products/hero",
            storageObjectId: "storage-1",
            extension: "jpg",
            contentType: "image/jpeg",
            sizeBytes: 123,
            title: "Hero",
            altText: "Product hero"
        )

        #expect(asset.status == .uploaded)
        #expect(asset.slugPath == "products/hero")
    }

    @Test
    func mediaAssetVariantStoresVariantAndProcessorIdentity() {
        let variant = Asset.File.Variant.Model.create(
            assetNodeFileId: "asset-1",
            variantId: "variant-1",
            variantProcessorId: "processor-1",
            storageObjectId: "object-1"
        )

        #expect(variant.assetNodeFileId == "asset-1")
        #expect(variant.variantId == "variant-1")
        #expect(variant.variantProcessorId == "processor-1")
        #expect(variant.storageObjectId == "object-1")
    }

    @Test
    func mediaAssetStorageObjectStoresCanonicalFileMetadata() {
        let object = StorageObject.Model.create(
            key: "variants/preview",
            extension: "webp",
            contentType: "image/webp",
            sizeInBytes: 123
        )

        #expect(object.key == "variants/preview")
        #expect(object.extension == "webp")
        #expect(object.contentType == "image/webp")
        #expect(object.sizeInBytes == 123)
    }

    @Test
    func mediaExtensionMatcherMatchesCanonicalExtension() {
        let asset = Asset.File.Model(
            id: "asset-1",
            folderId: nil,
            name: "hero",
            slug: "hero",
            slugPath: "hero",
            storageObjectId: "storage-1",
            extension: "jpg",
            contentType: "image/jpeg",
            sizeBytes: 123,
            status: .uploaded,
            title: nil,
            altText: nil,
            createdAt: .init(),
            updatedAt: .init(),
            deletedAt: nil
        )
        let processor = Variant.Processor.Model(
            id: "processor-1",
            variantId: "variant-1",
            name: "preview",
            matchExtensions: "png, jpg",
            commandTemplate: "cp {input.fullname} {output.fullname}",
            isActive: true,
            createdAt: .init(),
            updatedAt: .init()
        )

        #expect(
            Asset.ExtensionMatcher.matches(
                extension: asset.extension,
                processor: processor
            )
        )
    }
}
