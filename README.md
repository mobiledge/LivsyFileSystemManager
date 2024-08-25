# LivsyFileSystemManager

## A universal tool to perform CRUD operations via FileManager.

You can read more about in <a href="https://livsycode.com/blog/file-system-crud-operations-manager/">my article</a>.

## Installation

### Swift Package Manager

```
dependencies: [
    .package(url: "https://github.com/Livsy90/LivsyFileSystemManager.git")
]
```

## Example

```swift
let manager = FileSystemManager()

// Save
try? manager.save("Test", key: "test", directory: .cachesDirectory)

// Retrieve
let object = try? manager.retrieve(
    String.self,
    key: "test",
    directory: .cachesDirectory
)
print(object) // Test

// Delete
try? manager.delete(key: "test", directory: .cachesDirectory)
```
