import MediaApplication
import Testing

@Suite
struct HierarchicalObjectKeyGeneratorTestSuite {
    @Test
    func hierarchicalShardingIsEnabledByDefault() {
        let configuration = HierarchicalObjectKeyGenerator()

        #expect(configuration.depth == 2)
        #expect(configuration.segmentLength == 2)
    }

    @Test
    func shardingConfigurationNormalizesInvalidValues() {
        let configuration = HierarchicalObjectKeyGenerator(
            depth: -1,
            segmentLength: 0
        )

        #expect(configuration.depth == 0)
        #expect(configuration.segmentLength == 1)
    }

    @Test
    func buildsShardPrefixesForObjectKeys() throws {
        let sharder = HierarchicalObjectKeyGenerator(depth: 2, segmentLength: 2)

        #expect(try sharder.generate(from: "123456789") == "12/34/56789")
    }

    @Test
    func rejectsEmptyValues() {
        let generator = HierarchicalObjectKeyGenerator()

        #expect(throws: ObjectKeyGeneratorError.self) {
            try generator.generate(from: "")
        }
    }

    @Test
    func zeroDepthStillUsesAssetIDAsTheObjectNamespace() throws {
        let sharder = HierarchicalObjectKeyGenerator(depth: 0, segmentLength: 2)

        #expect(try sharder.generate(from: "123456789") == "123456789")
    }
}

@Suite
struct MediaPublicURLTestSuite {
    @Test
    func emitsReadableOriginalAndVariantURLsWithTheConfiguredPrefix() throws {
        let sharder = HierarchicalObjectKeyGenerator(depth: 2, segmentLength: 2)

        #expect(
            try mediaAssetPublicURL(
                id: "123456789",
                slugPath: "example/projects/hero-image",
                filename: "Hero Image",
                extension: "png",
                objectKeyGenerator: sharder
            ) == "/12/34/56789/originals/example/projects/Hero%20Image.png"
        )
        #expect(
            try mediaVariantPublicURL(
                assetId: "123456789",
                slugPath: "example/projects/hero-image",
                filename: "Hero Image",
                variantKey: "cover",
                extension: "webp",
                objectKeyGenerator: sharder
            )
                == "/12/34/56789/variants/cover/example/projects/Hero%20Image.webp"
        )
    }
}
