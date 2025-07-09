import XCTest
@testable import LivsyFileSystemManager

struct MockCodable: Codable, Equatable {
    let userId: UUID
    let fullName: String
}

final class LivsyFileSystemManagerTests: XCTestCase {
    
    var sut: FileSystemManager!
    let testKey = "testData.json"
    let testDirectory = FileManager.SearchPathDirectory.cachesDirectory
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = FileSystemManager()
    }
    
    override func tearDownWithError() throws {
        try? sut.delete(key: testKey, directory: testDirectory)
        sut = nil
        try super.tearDownWithError()
    }
    
    func testSaveAndRetrieve() throws {
        let mockData = MockCodable(userId: UUID(), fullName: "Test Object")
        
        try sut.save(mockData, key: testKey, directory: testDirectory)
        
        let retrievedData: MockCodable = try sut.retrieve(
            MockCodable.self,
            key: testKey,
            directory: testDirectory
        )
        
        XCTAssertEqual(retrievedData, mockData)
    }
    
    func testSaveAndRetrieve_WithCustomCoders() throws {
        let customEncoder = JSONEncoder()
        customEncoder.outputFormatting = .prettyPrinted
        customEncoder.keyEncodingStrategy = .convertToSnakeCase
        
        let customDecoder = JSONDecoder()
        customDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let mockData = MockCodable(userId: UUID(), fullName: "Jane Doe")
        let customCoderTestKey = "customCoderTest.json"
        
        try sut.save(
            mockData,
            key: customCoderTestKey,
            directory: testDirectory,
            encoder: customEncoder
        )
        
        let retrievedData: MockCodable = try sut.retrieve(
            MockCodable.self,
            key: customCoderTestKey,
            directory: testDirectory,
            decoder: customDecoder
        )
        
        XCTAssertEqual(retrievedData, mockData)
        
        try? sut.delete(key: customCoderTestKey, directory: testDirectory)
    }
    
    func testRetrieve_WhenFileDoesNotExist_ShouldThrowError() {
        let nonExistentKey = "nonExistentFile.json"
        
        XCTAssertThrowsError(
            try sut.retrieve(
                MockCodable.self,
                key: nonExistentKey,
                directory: testDirectory
            )
        )
    }
    
    func testDelete_WhenFileExists_ShouldRemoveFile() throws {
        let mockData = MockCodable(userId: UUID(), fullName: "Data to be deleted")
        
        try sut.save(
            mockData,
            key: testKey,
            directory: testDirectory
        )
        
        try sut.delete(
            key: testKey,
            directory:testDirectory
        )
        
        XCTAssertThrowsError(
            try sut.retrieve(
                MockCodable.self,
                key: testKey,
                directory: testDirectory
            )
        )
    }
    
    func testDelete_WhenFileDoesNotExist_ShouldThrowError() {
        let nonExistentKey = "anotherNonExistentFile.json"
        
        XCTAssertThrowsError(
            try sut.delete(
                key: nonExistentKey,
                directory: testDirectory
            )
        )
    }
}
