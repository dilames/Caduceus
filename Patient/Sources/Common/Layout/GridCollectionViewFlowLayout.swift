//
//  GridCollectionViewFlowLayout.swift
//  Patient
//
//  Created by Andrew Chersky  on 4/3/18.
//

import UIKit

final class GridCollectionViewFlowLayout: UICollectionViewFlowLayout {

    @IBInspectable
    var columnsCount: Int {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    var verticalItemSpacing: CGFloat {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    var horizontalItemSpacing: CGFloat {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    var itemsPerPage: CGFloat {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    var headerHeight: CGFloat {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    var leftSectionInset: CGFloat {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    var rightSectionInset: CGFloat {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    var topSectionInset: CGFloat {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    var bottomSectionInset: CGFloat {
        didSet {
            invalidateLayout()
        }
    }
    
    override init() {
        columnsCount = 0
        verticalItemSpacing = 0
        horizontalItemSpacing = 0
        itemsPerPage = 0
        headerHeight = 0.0
        leftSectionInset = 0.0
        rightSectionInset = 0.0
        topSectionInset = 0.0
        bottomSectionInset = 0.0
        super.init()
    }
    
    init(columnsCount: Int,
         verticalItemSpacing: CGFloat,
         horizontalSpacing: CGFloat,
         itemsPerPage: CGFloat,
         headerHeight: CGFloat,
         sectionInset: UIEdgeInsets)
    {
        self.columnsCount = columnsCount
        self.verticalItemSpacing = verticalItemSpacing
        self.horizontalItemSpacing = horizontalSpacing
        self.itemsPerPage = itemsPerPage
        self.headerHeight = headerHeight
        leftSectionInset = sectionInset.left
        rightSectionInset = sectionInset.right
        topSectionInset = sectionInset.top
        bottomSectionInset = sectionInset.bottom
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        columnsCount = 0
        verticalItemSpacing = 0
        horizontalItemSpacing = 0
        itemsPerPage = 0
        headerHeight = 0.0
        leftSectionInset = 0.0
        rightSectionInset = 0.0
        topSectionInset = 0.0
        bottomSectionInset = 0.0
        super.init(coder: aDecoder)
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        minimumLineSpacing = verticalItemSpacing
        minimumInteritemSpacing = horizontalItemSpacing
        headerReferenceSize = CGSize(width: collectionView.bounds.width, height: headerHeight)
        sectionInset = UIEdgeInsets(top: topSectionInset, left: leftSectionInset,
                                    bottom: bottomSectionInset, right: rightSectionInset)
        
        let minWidth = min(collectionView.frame.height, collectionView.frame.width)
        let estimatedItemWidth = (minWidth - verticalItemSpacing * CGFloat(columnsCount - 1)
            - sectionInset.left - sectionInset.right) / CGFloat(columnsCount)
        let collectionContentHeight = collectionView.bounds.height
            - collectionView.safeAreaInsets.top - collectionView.safeAreaInsets.bottom
        	- sectionInset.top - sectionInset.bottom
        let itemHeight = collectionContentHeight / itemsPerPage
        
        var itemSize: CGSize = .zero
        itemSize.width = estimatedItemWidth
        itemSize.height = itemHeight
        
        self.itemSize = itemSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return newBounds.size != collectionView.bounds.size
    }
}
