class EndPoints {
  // test
  static const String baseUrl =
      "http://78.89.159.126:9393/TheOneAPIMazyad/api/";
  // mazyad
  // static const String baseUrl = "http://78.89.159.126:9393/TheOneAPIMazyad";

  static const String register = "Customer/AddCustomer";
  static const String login = "Customer/Login";
  static String bannerOne = "Baner1";
  static String biggestDiscount = "Product/GetProductsWithBiggestDiscount";
  static String bestSeller = "Product/GetProductsWithBestSeller";
  static String newProduct = "Product/GetNewProducts";
  static const String getMainCategory = "Category/GetMainCategory";
  static const String getSubCategory = "Category/GetCategoryByParentId";

  static String subCategoryProducts = "Product/GetProductsByCategory";
  static String branches = "CompanyBranches";

  static String productDetails = "Product/GetProductById";
  static String addToBasket = "Product/AddSalesBasket";
  static String deleteOneItemFromBasket = "Product/DeleteSalesBasketPost";
  static String getCustomerBasket = "Product/GetCustomerSalesBasket";
  static String addOrder = "Order";
  static String getOrdersDetails = "Order/GetOrderProductsByCustomerID";

  static String searchProducts = "Product/SearchProducts";
  static String searchProductByBarcode = "Product/SearchProductByBarcode";

  static const String addNewAddress = "Customer/AddCustomerAddress";
  static const String addFavorite = "Customer/AddCustomerProduct";

  static const String deleteFavorite = "Customer/DeleteCustomerProduct";
  static const String getFavorite = "Customer/GetCustomerProducts";
  static const String getPreviousOrders = "Order/GetOrdersByCustomerID";
  static String deleteAccount = "Customer/DeleteCustomerByCustomerID";
  static const String privacyAndPlo = "Privacy";
  static const String savedAddresses = "Customers/GetCustomerAddress";
  static const String deleteAddress = "Customer/DeleteCustomerAddress";
  static String changePassword = "Customer/ChangePassword";
  static const String aboutUS = "AboutUs";

  static const String addEvaluation = "Product/AddEvaluation";
  static const String getProductEvaluationByID =
      "Product/GetProductEvaluationByID";

  /// todo sendVerificationCode
  static const String sendVerificationCode = "اااا";

  //.
  //.
  static String newsMarquee = "News";

  //.
  // get areas
  static String getAreas = "Areas";
  static String getAreaByGovernorateId = "Areas/GetAreaByGovernorateId";

  static const String updateUser = "/user/update";
  static const String governorates = "Governorates";

  static String offerOne = "Offer1";
  static String offerTwo = "Offer2";
  static String offerThree = "Offer3";
  static String offerFour = "Offer4";
  static String offerFive = "Offer5";
  static String allOffer = "Offers";

  static String bannerTwo = "Baner2";
  static String bannerThree = "Baner3";
}
