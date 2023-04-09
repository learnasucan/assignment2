//
//  HomeScreenController.swift
//  Project2
//
//  Created by Prachit on 04/04/23.
//

import UIKit

let kNumberOfproductsInGrid = 3

class HomeScreenController: UIViewController {
    
    var components: [Component] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load data from JSON file
        loadDataFromJsonFile(name: "data", fileType: "json")
        
        // Set up collection view
        registerCollectionViewCells()
        
        //  Set up compositional layout
        setupCompositionalLayout()
        
        searchBar.delegate = self
        
    }

}

//MARK: - Delegates

extension HomeScreenController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return components.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let component = components[section]
        return component.cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let component = components[indexPath.section]
        let cellData = component.cells[indexPath.row]
        
        switch component.type {
        case .image:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
                fatalError("Failed to dequeue ImageCell.")
            }
            cell.configure(with: cellData)
            return cell
            
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCell else {
                fatalError("Failed to dequeue GridCell.")
            }
            cell.configure(with: cellData)
            return cell
            
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? ListCell else {
                fatalError("Failed to dequeue ListCell.")
            }
            cell.configure(with: cellData)
            return cell
            
        case .none:
            return UICollectionViewCell()
            
        }
    }
    
    
}

//MARK: - Helpers

extension HomeScreenController {
    
    fileprivate func loadDataFromJsonFile(name: String, fileType: String) {
        
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(ResponseData.self, from: jsonData)
                components = responseData.components
            } catch {
                print("Error loading data: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func registerCollectionViewCells() {
        
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(UINib(nibName: "GridCell", bundle: nil), forCellWithReuseIdentifier: "GridCell")
        collectionView.register(UINib(nibName: "ListCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
    }
    
    
    fileprivate func setupCompositionalLayout() {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.sectionLayout(for: sectionIndex)
        }
        collectionView.collectionViewLayout = layout
    }
    
    fileprivate func sectionLayout(for sectionIndex: Int) -> NSCollectionLayoutSection {
        // Determine the layout for the section based on the component type
        var component = components[sectionIndex]
        
        let section: NSCollectionLayoutSection
        
        switch component.type {
        case .image:
            section = createImageSection()
        case .grid:
            section = createGridSection(cellsCount: kNumberOfproductsInGrid)
        case .list:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(180))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            section = createListSection(cellsCount: 1)
        default:
            fatalError("Unsupported component type")
        }
        
        return section
    }
    
    func createImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        return section
    }
    
    func createGridSection(cellsCount: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //if edge required
        //item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: kNumberOfproductsInGrid)
        
        //scrolling behavour for 3 cell display
        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
//        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        return section
    }
    
    func createListSection(cellsCount: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(220))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(220))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: cellsCount)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        return section
    }
    
}


extension HomeScreenController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
           // Your search code here
       }

       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           // Your cancel button code here
       }
    
}
