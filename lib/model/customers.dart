class Customer {
  String displayName;
  String email;
  String address;
  String customerGroupId;
  String phoneNumber;
  String idCard;
  String photoUrl;
  int numOfFaces;
  int recyclePoints;
  int totalParcels;
  int totalPickedUp;
  String userFaceId;
  String userUID;

  Customer(
      {this.displayName,
      this.email,
      this.address,
      this.customerGroupId,
      this.phoneNumber,
      this.idCard,
      this.photoUrl,
      this.numOfFaces,
      this.recyclePoints,
      this.totalParcels,
      this.totalPickedUp,
      this.userFaceId,
      this.userUID});

//  Map<String, dynamic> toJson() => {
//    'uid': uid,
//    'email': email,
//    'displayName': displayName,
//    'photoUrl': photoUrl,
//    'location': location,
//    'userAgreement': userAgreement,
//    'birthday': birthday,
//    'gender': gender,
//    'phoneNumber': phoneNumber,
//    'lovedPlaces': [],
//    'lovedFood': [],
//    'lovedEntertainment': [],
//    'bookmarkedPlaced': [],
//    'bookmarkedFood': [],
//    'bookmarkedEntertainment': [],
//  };

  factory Customer.fromMap(Map<String, dynamic> data) {
    return Customer(
        email: data['email'] ?? '',
        displayName: data['name'] ?? '',
        phoneNumber: data['phone'] ?? '',
        photoUrl: data['photoUrl'] ?? '',
        address: data['addr'] ?? '',
        customerGroupId: data['customerGroupId'] ?? '',
        idCard: data['id_card'] ?? '',
        numOfFaces: data['num_faces'] ?? 0,
        recyclePoints: data['recyclePoints'] ?? 0,
        totalParcels: data['totalParcels'] ?? 0,
        totalPickedUp: data['totalPickedUp'] ?? 0,
        userFaceId: data['userFaceID'],
        userUID: data['userUID']);
  }
}
