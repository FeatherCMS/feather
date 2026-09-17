import MediaApplication
import Testing

@Suite
struct MediaStorageConfigurationTestSuite {
    @Test
    func disabledShardingIsTheDefault() {
        let configuration = MediaStorageShardConfiguration()

        #expect(configuration.depth == 0)
        #expect(configuration.segmentLength == 2)
        #expect(configuration.isEnabled == false)
    }

    @Test
    func shardingConfigurationNormalizesInvalidValues() {
        let configuration = MediaStorageShardConfiguration(
            depth: -1,
            segmentLength: 0
        )

        #expect(configuration.depth == 0)
        #expect(configuration.segmentLength == 1)
    }
}
