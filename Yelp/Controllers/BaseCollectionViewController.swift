//
//  BaseCollectionViewController.swift
//  Yelp
//
//  Created by Nkommuri on 13/03/22.
//

import UIKit

protocol ContentDelegate {
    func loadData()
    func registerCells()
    func headerrItems() -> [String]
}

extension ContentDelegate{
    func headerrItems() -> [String]{
        return []
    }
}

class BaseCollectionViewController: UIViewController {

    init() {
        super.init(nibName: "BaseCollectionViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var newController:UIViewController?{
        didSet{
            if let controller = newController {
                navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    @IBOutlet weak var baseCollectionView:UICollectionView!
    var contentDelegate:ContentDelegate? = nil{
        didSet{
            contentDelegate?.registerCells()
            contentDelegate?.loadData()
        }
    }
    
    var items:[[Any]] = []{
        didSet{
            DispatchQueue.main.async { [weak self] in
                self?.baseCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentDelegate?.registerCells()
        baseCollectionView.delegate = self
        baseCollectionView.dataSource = self
        baseCollectionView.collectionViewLayout = customCollectionLayout()
    }
    
    func getLayout(_ section:Int) -> NSCollectionLayoutSection {
        return defaultLayout()
    }
}

extension BaseCollectionViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return headerCell(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension BaseCollectionViewController{
    
    @objc func headerCell(_ indexPath:IndexPath) -> UICollectionReusableView{
        return UICollectionReusableView()
    }
    
    func customCollectionLayout() -> UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout{[weak self](section,_) in
            return self?.getLayout(section)
        }
        return layout
    }
    
    
    func defaultLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 15
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(0.5))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    /**
     - Parameters:
        - sectionPadding: Dimension with top,left,bottom,right
    **/
    internal func getDCLayout(type:CollectionType = .Horizontal,itemWH:SizeDimension = (1,1), groupWH:SizeDimension = (1,1),headerWH:SizeDimension = zeroWH,itemPadding:Dimension = (0,8,0,8),sectionPadding:Dimension = (0,10,10,10),isGroupPaging:Bool = true) -> NSCollectionLayoutSection {
        
        let itemWidth:NSCollectionLayoutDimension = (itemWH.0 <= 1) ? .fractionalWidth(itemWH.0) : .absolute(itemWH.0)
        let itemHeight:NSCollectionLayoutDimension = (itemWH.1 <= 1) ? .fractionalHeight(itemWH.1) : .absolute(itemWH.1)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension:itemHeight)
       
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: itemPadding.0, leading: itemPadding.1, bottom: itemPadding.2, trailing: itemPadding.3)
        
        let groupWidth:NSCollectionLayoutDimension = (groupWH.0 <= 1) ? .fractionalWidth(groupWH.0) : .absolute(groupWH.0)
        let groupHeight:NSCollectionLayoutDimension = (groupWH.1 <= 1) ? .fractionalWidth(groupWH.1) : .absolute(groupWH.1)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension:groupHeight)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: sectionPadding.0, leading: sectionPadding.1, bottom: sectionPadding.2, trailing: sectionPadding.3)
        
        if (headerWH != (0,0)) {
            let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(headerWH.0),
                heightDimension: .absolute(headerWH.1)
            )
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
        }
        
        if (type != .Vertical && isGroupPaging) {
            section.orthogonalScrollingBehavior = .continuous
        }
        return section
    }
}
