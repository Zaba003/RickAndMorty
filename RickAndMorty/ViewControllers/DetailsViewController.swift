//
//  DetailsViewController.swift
//  RickAndMorty
//
//  Created by Кирилл Заборский on 07.07.2020.
//  Copyright © 2020 Кирилл Заборский. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var characterImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    // MARK: - Public properties
    var character: Result!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCharacterImageView()
        view.backgroundColor = .black
        transform(for: characterImageView,
                  nameAnimation: "transform.scale",
                  duration: 0.8,
                  fromValue: 0.97,
                  toValue: 1.93,
                  autoreverses: true,
                  repeatCount: Float.greatestFiniteMagnitude)
        
        setupLabels()
        setupNavigationBar()
    }
    
    // MARK: - Private methods
    
    private func setupCharacterImageView() {
        characterImageView.layer.cornerRadius = characterImageView.bounds.width / 2
        characterImageView.backgroundColor = .white
        
        DispatchQueue.global().async {
            let stringUrl = self.character.image
            guard let imageUrl = URL(string: stringUrl) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                self.characterImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    private func setupLabels() {
        nameLabel.text = "My name is \(character.name)"
        statusLabel.text = "Status - \(character.status)"
        speciesLabel.text = "Species - \(character.species)"
        genderLabel.text = "Gender - \(character.gender)"
        originLabel.text = "Origin - \(character.origin.name)"
        locationLabel.text = "Location - \(character.location.name)"
    }
    
    private func setupNavigationBar() {
        title = character.name
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}
