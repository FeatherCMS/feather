import Foundation
import Testing

@testable import MediaDomain

@Suite
struct MediaDomainModelTestSuite {
    @Test
    func mediaAssetCreateDefaultsToUploadedStatus() {
        let asset = MediaAssetNodeFile.create(
            folderId: "folder-1",
            name: "hero",
            slug: "hero",
            slugPath: "products/hero",
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
    func mediaAssetVariantStoresProcessorAndObjectIdentity() {
        let variant = MediaAssetNodeFileVariant.create(
            nodeId: "asset-1",
            processorId: "processor-1",
            name: "image_preview",
            storageObjectId: "object-2",
            objectKey: "assets/asset-1/variants/processor-1.webp",
            extension: "webp"
        )

        #expect(variant.nodeId == "asset-1")
        #expect(variant.processorId == "processor-1")
        #expect(variant.objectKey.hasSuffix(".webp"))
    }

    @Test
    func mediaExtensionMatcherMatchesCanonicalExtension() {
        let asset = MediaAssetNodeFile(
            id: "asset-1",
            folderId: nil,
            name: "hero",
            slug: "hero",
            slugPath: "hero",
            storageObjectId: "object-1",
            objectKey: "assets/asset-1/original.jpg",
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
        let processor = MediaProcessor(
            id: "processor-1",
            name: "image_preview",
            matchExtensions: "png, jpg",
            commandTemplate: "cp {input.fullname} {output.fullname}",
            isRequired: false,
            isActive: true,
            createdAt: .init(),
            updatedAt: .init()
        )

        #expect(MediaExtensionMatcher.matches(asset: asset, processor: processor))
    }
}
