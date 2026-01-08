class ApiPath {
  static String users(String userId) => "users/$userId";

  static String products() => "products/";
  static String product(String productId) => "products/$productId";

  static String addToCart(String userId, String productId) =>
      "users/$userId/cart/$productId";
  static String userCart(String userId) => "users/$userId/cart/";

  static String favorite(String userId, String productId) =>
      "users/$userId/favorites/$productId";
  static String userFavorite(String userId) => "users/$userId/favorites/";

  static String categories() => "categories/";
  static String homeCarousel() => "annoucments/";

  static String paymentMethods(String userId) =>
      "users/$userId/paymentMethods/";
  static String paymentMethod(String userId, String paymentMethodId) =>
      "users/$userId/paymentMethods/$paymentMethodId";

  static String location(String userID, String locationId) =>
      "users/$userID/locations/$locationId";
  static String locations(String userID) => "users/$userID/locations/";
}
