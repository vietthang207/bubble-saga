// Copyright (c) 2017 NUS CS3217. All rights reserved.

/**
 An enum of errors that can be thrown from the `Queue` struct.
 */
enum QueueError: Error {
    /// Thrown when trying to access an element from an empty queue.
    case emptyQueue
}


/**
 A generic `Queue` class whose elements are first-in, first-out.
 
 - Authors: CS3217
 - Date: 2017
 */
struct Queue<T> {
    
    var items: [T] = []
    var head = 0, tail = 0, size = 0, capacity = 0
    
    /// Adds an element to the tail of the queue.
    /// - Parameter item: The element to be added to the queue
    mutating func enqueue(_ item: T) {
        if capacity == 0 {
            items.append(item)
            capacity = 1
            size = 1
            head = 0
            tail = 0
            return
        }
        
        if size == 0 {
            items[0] = item
            head = 0
            tail = 0
            size = 1
            return
        }
        
        if size == capacity {
            //enlarge the queue's capacity
            items = items + items
            if head != 0 {
                head += size
            }
            capacity *= 2
        }
        if tail < capacity - 1 {
            tail += 1
            items[tail] = item
            size += 1
        } else {
            tail = 0
            items[tail] = item
            size += 1
        }
    }
    
    /// Removes an element from the head of the queue and return it.
    /// - Returns: item at the head of the queue
    /// - Throws: QueueError.EmptyQueue
    mutating func dequeue() throws -> T {
        if size == 0 {
            throw QueueError.emptyQueue
        } else {
            let res = items[head]
            if head == capacity - 1 {
                head = 0
            } else {
                head += 1
            }
            size -= 1
            return res
        }
    }
    
    /// Returns, but does not remove, the element at the head of the queue.
    /// - Returns: item at the head of the queue
    /// - Throws: QueueError.EmptyQueue
    func peek() throws -> T {
        if size == 0 {
            throw QueueError.emptyQueue
        } else {
            return items[head]
        }
    }
    
    /// The number of elements currently in the queue.
    var count: Int {
        return size
    }
    
    /// Whether the queue is empty.
    var isEmpty: Bool {
        return size == 0
    }
    
    /// Removes all elements in the queue.
    mutating func removeAll() {
        items = []
        size = 0
        capacity = 0
        head = 0
        tail = 0
    }
    
    /// Returns an array of the elements in their respective dequeue order, i.e.
    /// first element in the array is the first element to be dequeued.
    /// - Returns: array of elements in their respective dequeue order
    func toArray() -> [T] {
        if size == 0 {
            return []
        } else if tail >= head {
            return Array(items[head...tail])
        } else {
            return Array(items[head..<capacity] + items[0...tail])
        }
    }
}
