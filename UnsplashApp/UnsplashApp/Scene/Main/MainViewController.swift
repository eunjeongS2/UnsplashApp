//
//  ViewController.swift
//  UnsplashApp
//
//  Created by eunjeong lee on 2021/01/08.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet private weak var imageCollectionView: UICollectionView!
    private var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        images = mockupImages()
    }
    
    private func configureCollectionView() {
        ImageCollectionViewCell.registerNib(collectionView: imageCollectionView)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    private func mockupImages() -> [UIImage] {
        let imagesURL = [
            "https://lh3.googleusercontent.com/proxy/wiLbq-P2WTDqpcqcN8N3EXXZgUK-mHV2V73-jbBCvWVnp6nvaVaPHYZp6i_Z-MqiOMmmKb8c5tCLcXI-EIfJRE69ccPnL-lZHtQ8Y4V-e_Y5cogRsHF6ffT3RaCmXmN7W3vSncK0nGvLjDMnBZfY85I",
            "https://i.ytimg.com/vi/ohtkpDDezLo/maxresdefault.jpg",
            "https://image.imnews.imbc.com/news/2013/culture/article/__icsFiles/afieldfile/2013/04/07/32.jpg",
            "https://image.auction.co.kr/itemimage/14/97/95/1497951b06.jpg"
        ]
        let datas = imagesURL.compactMap { URL(string: $0) }.compactMap { try? Data(contentsOf: $0) }
        
        return datas.compactMap { UIImage(data: $0) }
    }

}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = ImageCollectionViewCell.Identifier.reusableCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        guard let imageCell = cell as? ImageCollectionViewCell else { return cell }
        
        imageCell.configureCell(image: images[indexPath.item])
        
        return imageCell
    }
    
}

extension MainViewController: UICollectionViewDelegate {}
