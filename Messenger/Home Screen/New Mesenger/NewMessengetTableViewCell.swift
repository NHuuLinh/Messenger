//
//  NewMessengetTableViewCell.swift
//  Messenger
//
//  Created by LinhMAC on 18/02/2024.
//

import UIKit

class NewMessengetTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func blinData(data: User) {
        userName.text = data.name
        userEmail.text = data.email
        userPhoneNumber.text = data.phoneNumber
    }
    
}
