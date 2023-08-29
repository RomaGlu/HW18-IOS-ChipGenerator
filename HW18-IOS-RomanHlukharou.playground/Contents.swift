import Foundation

let storage = Storage(counter: 0)
let generator = GenerateChip(storage: storage)
let worker = WorkChip(storage: storage)

generator.start()
worker.start()
