import Testing
import Foundation
@testable import MediaDomain

@Suite
struct MediaDomainModelTestSuite {

    @Test
    func mediaAssetCreateDefaultsToUploadedStatus() {
        let new = MediaAsset.create(
            id: "asset-1",
            storageKey: "media/assets/asset-1",
            type: "jpeg",
            sizeBytes: 123,
            title: "title",
            altText: "alt"
        )

        #expect(new.status == .uploaded)
        #expect(new.type == "jpeg")
        #expect(new.sizeBytes == 123)
    }

    @Test
    func mediaExtensionMatcherPrefersStorageKeyExtension() {
        let asset = MediaAsset(
            id: "asset-1",
            storageKey: "media/assets/asset-1.jpg",
            type: "application/octet-stream",
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

        #expect(
            MediaExtensionMatcher.matches(asset: asset, processor: processor)
        )
    }

    @Test
    func mediaProcessorAssetCreateStoresStorageKey() {
        let link = MediaProcessorAsset.create(
            id: "link-1",
            assetId: "asset-1",
            processorId: "processor-1",
            storageKey: "media/assets/asset-1/image_preview.jpeg"
        )

        #expect(link.assetId == "asset-1")
        #expect(link.processorId == "processor-1")
        #expect(link.storageKey == "media/assets/asset-1/image_preview.jpeg")
    }
}
