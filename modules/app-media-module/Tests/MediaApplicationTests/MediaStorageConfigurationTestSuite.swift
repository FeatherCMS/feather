import MediaApplication
import Testing

@Suite
struct MediaStorageKeyShardTestSuite {
    @Test
    func disabledShardingIsTheDefault() {
        let configuration = MediaStorageKeyShard()

        #expect(configuration.depth == 0)
        #expect(configuration.segmentLength == 2)
        #expect(configuration.isEnabled == false)
    }

    @Test
    func shardingConfigurationNormalizesInvalidValues() {
        let configuration = MediaStorageKeyShard(
            depth: -1,
            segmentLength: 0
        )

        #expect(configuration.depth == 0)
        #expect(configuration.segmentLength == 1)
    }
}
