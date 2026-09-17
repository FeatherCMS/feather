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
    func mediaAssetVariantStoresVariantAndProcessorIdentity() {
        let variant = MediaAssetNodeFileVariant.create(
            nodeId: "asset-1",
            variantId: "variant-1",
            variantProcessorId: "processor-1",
            name: "preview",
            storageObjectId: "object-2",
            objectKey: "/media/assets/asset-1/variants/processor-1.webp",
            extension: "webp"
        )

        #expect(variant.nodeId == "asset-1")
        #expect(variant.variantId == "variant-1")
        #expect(variant.variantProcessorId == "processor-1")
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
            objectKey: "/media/assets/asset-1/original.jpg",
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
        let processor = MediaVariantProcessor(
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
            MediaExtensionMatcher.matches(
                extension: asset.extension,
                processor: processor
            )
        )
    }
}
