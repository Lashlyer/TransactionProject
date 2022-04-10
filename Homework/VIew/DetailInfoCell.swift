
import Foundation
import UIKit
import SnapKit

class DetailInfoCell: UITableViewCell {
    
    static let identifier = "DetailInfoCell"
    
    private let titlelabel : UILabel = {
        return UILabel()
    }()
    
    private let quantitylabel : UILabel = {
        return UILabel()
    }()
    
    private let pricelabel : UILabel = {
        return UILabel()
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContentView() {
        contentView.addSubview(titlelabel)
        contentView.addSubview(quantitylabel)
        contentView.addSubview(pricelabel)
    }
    
    private func autoLayout() {
        titlelabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(20)
        }
        
        quantitylabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(60)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(20)
        }

        pricelabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(100)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(20)
        }
        
    }
    
    func setValue(datas: DetailTransationParameter) {
        self.titlelabel.text = "名稱：\(datas.name)"
        self.quantitylabel.text = "數量：\(datas.quantity)"
        self.pricelabel.text = "價格：\(datas.price)"
    }
    
}
