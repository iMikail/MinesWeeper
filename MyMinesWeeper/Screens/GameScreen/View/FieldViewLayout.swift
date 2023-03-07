//
//  Field.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 6.10.22.
//

import UIKit
// Образец: https://www.credera.com/insights/building-a-multi-directional-uicollectionview-in-swift

class FieldViewLayout: UICollectionViewLayout {
    let cellHeight = 30.0
    let cellWidth = 30.0
    var cellAttrsDictionary = [IndexPath: UICollectionViewLayoutAttributes]()
    var contentSize = CGSize.zero

    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }

    override func prepare() {
        guard collectionView != nil else {
            print("collectionView = nil")
            return
        }
        // Cycle through each section of the data source.
        if collectionView!.numberOfSections > 0 {
            for section in 0...collectionView!.numberOfSections - 1 where
            collectionView!.numberOfItems(inSection: section) > 0 {

                // Cycle through each item in the section.
                for item in 0...collectionView!.numberOfItems(inSection: section) - 1 {

                    // Build the UICollectionVieLayoutAttributes for the cell.
                    let cellIndex = IndexPath(item: item, section: section)
                    let xPos = Double(item) * cellWidth
                    let yPos = Double(section) * cellHeight

                    let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                    cellAttributes.frame = CGRect(x: xPos, y: yPos, width: cellWidth, height: cellHeight)

                    // Determine zIndex based on cell type.
                    if section == 0 && item == 0 {
                        cellAttributes.zIndex = 4
                    } else if section == 0 {
                        cellAttributes.zIndex = 3
                    } else if item == 0 {
                        cellAttributes.zIndex = 2
                    } else {
                        cellAttributes.zIndex = 1
                    }

                    // Save the attributes.
                    cellAttrsDictionary[cellIndex] = cellAttributes
                }
            }
        }

        // Update content size.
        let contentWidth = Double(collectionView!.numberOfItems(inSection: 0)) * cellWidth
        let contentHeight = Double(collectionView!.numberOfSections) * cellHeight
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values where rect.intersects(cellAttributes.frame) {
            attributesInRect.append(cellAttributes)
        }
        // Return list of elements.
        return attributesInRect
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
}
