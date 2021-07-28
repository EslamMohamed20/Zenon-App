


class ZenonAdminModel{
 final String adminName;
 final String adminPassword;

  ZenonAdminModel({
    this.adminName, 
    this.adminPassword,
  });
  
     factory ZenonAdminModel.fromJson(Map<String, dynamic> json) => ZenonAdminModel(
        adminName: json["adminName"],
        adminPassword: json["adminPassword"],
    );


}


