import '../configs/Env.dart';


bool isProd = false;

String prospectRoute =  isProd ? "$spiroRouteProd/Prospect/" : "$spiroRouteLocal:20002/Prospect/";

String partnersRoute = isProd ? "$spiroRouteProd/Partners/" : "$spiroRouteLocal:20005/Partners/";

String relayRoute = isProd ? "$spiroRouteProd/spiroRelay" : "$spiroRouteLocal:/spiroRelay";



String deviceReg = "Device/NewDevice";

String inaugurateProspect = 'InAugurate/Prospect';

String uploadProfileImage = 'InAugurate/ProfilePicture';

String getIdentificationTypesProspects = 'Identification/Types';



String getLocation = 'spiro/Location/FindLocation';

String loginUser = 'User/Login';


String terminateAccount = 'User/Terminate';

String logoutRequest = 'User/Logout';

String accountRecovery = "User/RecoverRequest";

String accountRecoveryCredentials = "User/RecoverRequestCredentials";

String accountRecoveryCancellation = "User/RecoverRequestCancellation";

String accountRecoveryUpdate = "User/RecoverRequestUpdate";

String loginRequest = 'User/LoginRequest';




String myClientList = 'InAugurate/Clients';

String deviceToken = 'Device/Note';

String myNationalities = 'InAugurate/Nationalities';

String myIdTypes = 'InAugurate/IdentificationTypes';

String aboutMe = 'User/Me';

String myCountryCodes = 'InAugurate/CountryCodes';

String registerCredentialsLocation = 'InAugurate/UserAndPass';

String verifyRegCredentials = 'InAugurate/CredentialVerification';

String myCompanies = 'Company/Mine';

String myEmployeeCompanies = 'Company/Mine';

String companyRegistrationSplash = 'Company/RegistrationSplash';

String uploadNewCompanyBackDrop = 'Company/NewBackDrop';

String uploadNewCompanyLogo  = 'Company/NewLogo';

String uploadProductNewImage = 'Products/NewRegistrationImage';

String uploadProductAdditionalNewImage  = 'Products/NewAdditionalRegistrationImage';

String uploadInventoryBackDrop = 'Inventory/NewRegistrationBackDrop';

String uploadInventoryNewImage = 'Inventory/NewRegistrationImage';

String uploadProductCollectionNewImage = 'Products/NewCollectionRegistrationImage';

String uploadProductCollectionNewBackDropImage = 'Products/NewProductCollectionImageBackDrop';

String uploadProductNewBackDropImage = 'Products/NewRegistrationBackDrop';

String inAugurateCompany = 'Company/InAugurate';

String getCompanyTypesRequest = 'Company/Types';

String getAllCountries = 'Country/All';

String getAllCompanyOperations = 'Company/OperationTypes';

String getCompanyFieldOfOperations = 'Company/OperationalIndustries';

String getMobileExtensionsLink = 'Contacts/AllExtensions';

String getCompanyStateRequest = 'Company/State';

String saveServiceTag = 'Services/NewTag';

String saveProductTag = 'Products/NewTag';

String getActiveProductTags = 'Products/MyActiveTags';

String getAllProductTags = 'Products/MyTags';

String getActiveServiceTags = 'Services/MyActiveTags';

String getAllServiceTags = 'Services/MyTags';

String fetchProductTypes = 'Products/Types';

String fetchInventoryTypes = 'Inventory/Types';

String ownerDashboardDetails = 'Company/GroupFinancials';

String fetchCurrencies = 'Currency/All';

String fetchProductCategories = 'Products/Categories';

String fetchInventoryCategories = 'Inventory/Categories';

String fetchProductQuality = 'Products/Qualities';

String fetchInventoryQuality = 'Inventory/Qualities';

String fetchProductSpecs = 'Products/SpecsByType';

String saveProductRequest = 'Products/New';

String registerSpecificationRequest  = 'Products/SaveSpecification';

String fetchAllDeductions = 'Deductions/All';

String fetchAllProductDeductions = 'Deductions/AllProductDeductions';

String fetchAllInventoryDeductions = 'Deductions/AllInventoryDeductions';

String fetchAllProductTaxes = 'Taxes/AllProductTaxes';

String fetchAllTaxes = 'Taxes/All';

String fetchAllInventoryTaxes = 'Taxes/AllInventoryTaxes';

String myCompanyEmployee = 'Employee/Mine';

String modifyProductRights = 'Employee/AssignProductRights';

String modifyFinanceRights = 'Employee/AssignFinanceRights';

String modifyInventoryRights = 'Employee/AssignInventoryRights';

String modifyOrderRights = 'Employee/AssignOrderRights';

String modifyManagementRights = 'Employee/AssignManagementRights';

String allFinanceRights = 'Rights/Finance';

String allOrderRights = 'Rights/Order';

String allInventoryRights = 'Rights/Inventory';

String allManagementRights = 'Rights/Management';

String myEmployeeRights = 'Employee/EmployeeRights';

String myUserRights = 'Employee/MyRights';

String deductionsUnderInventoryTypeRequest = 'Deductions/AllInventoryDeductions';

String registerTaxation = 'Taxes/New';

String registerDeduction = 'Deductions/New';

String offeredProductTypesRequest = 'Products/OfferedProductTypes';

String offeredInventoryTypesRequest = 'Inventory/OfferedInventoryTypes';

String productDashboardInfoRequest = 'Products/GraphOverview';

String productRecentlyStocked = 'Products/RecentlyStocked';

String topProductSalesRequest = 'Products/TopProductSold';

String myProducts = 'Products/Mine';

String activeProducts = 'Products/AllActive';

String myInventory = 'Inventory/Mine';

String productImageRequest = 'Products/Image';

String inventoryImageRequest = 'Inventory/Image';

String registerProductCollection = 'Products/NewCollection';

String recentTransactions = 'Payments/Recent';

String companyProductStockHistory  = 'Stock/ProductHistory';

String companyInventoryStockHistory = 'Stock/InventoryHistory';

String updateProductDetailsLocation = 'Products/UpdateDetails';

String updateInventoryDetailsLocation = 'Inventory/UpdateDetails';

String updateProductCollectionDetailsLocation = 'Products/UpdateCollectionsDetails';

String updateProductGroupDetailsLocation = 'Products/UpdateGroupingDetails';

String companyProductStockItemHistory  = 'Stock/ProductStockItemHistory';

String companyInventoryStockItemHistory  = 'Stock/InventoryStockItemHistory';

String companyProductHistory = 'Products/History';

String companyInventoryHistory = 'Inventory/History';

String companyEmployeeHistory = 'Employee/History';

String fireEmployee = 'Employee/Release';

String companyProductCollectionHistory = 'Products/ProductCollectionHistory';

String companyProductGroupingHistory = 'Products/ProductGroupHistory';

String companyOrderHistory = 'Orders/History';

String getOrderGroupingSounds = 'Orders/GetAvailableOrderGroupSounds';

String companyProductCategories = 'Products/ExistingCompanyProductCategories';

String companyProductStockItems  = 'Stock/ProductStockItems';

String companyInventoryStockItems  = 'Stock/InventoryStockItems';

String stockProductUp = 'Stock/ProductStockUp';

String stockInventoryUp = 'Stock/InventoryStockUp';

String updateProductStockItem = 'Stock/NewProductStockItem';

String updateInventoryStockItem = 'Stock/NewInventoryStockItem';

String isProductStocked = 'Stock/IsProductStocked';

String isInventoryStocked = 'Stock/IsInventoryStocked';

String requestMyUserCodePath = 'Employee/GenerateLinkCode';

String requestCompanyLink = 'Employee/CompanyLink';

String syncEmployeeWithOrgPath = 'Employee/SyncAndComplete';

String onboardClientToOrganisation = 'Employee/SynchronizeClient';

String employeeCodeVerificationAndGeneration = 'Employee/GenerateUserLink';

String companyPaymentOptions = 'Payments/Offered';

String companyStatementRequest = 'Finance/MonthsTotals';

String companyProductStockOrderAvailable = 'Orders/AvailableProducts';

String orderCancellation  = 'Orders/Cancel';

String orderCompletion  = 'Orders/Complete';

String fetchAllOrderGrouping  = 'Orders/AllOrderGroups';

String saveOrderGroup = 'Orders/RegisterOrderGroups';

String productPriceDeductions = 'Deductions/ProductDeductions';

String inventoryPriceDeductions = 'Deductions/InventoryDeductions';

String productPrices = 'Products/ProductPrice';

String inventoryPrices = 'Inventory/InventoryPrice';

String inventoryChart = 'Inventory/ChartData';

String inventoryRunningLow = 'Inventory/RunningLow';

String inventoryRecentlyStocked = 'Inventory/RecentlyStocked';

String productTypePrices = 'Products/ProductTypePrices';

String inventoryTypePrices = 'Inventory/InventoryTypePrices';

String stockItemPriceHistory = 'Stock/StockItemPriceHistory';

String stockPriceHistory = 'Stock/StockPriceHistory';

String stockItemPrices = 'Stock/StockItemTypePrices';

String stockPrices = 'Stock/StockTypePrices';

String modifyProductPrice = 'Products/UpdatePrice';

String modifyInventoryPrice = 'Inventory/UpdatePrice';

String modifyStockItemPrice = 'Stock/UpdateStockItemProductPrice';

String getHighPriorityAds = 'Ads/Prior';

String fetchAllAds = 'Ads/All';

String setViewingEnded  = 'Ads/ViewEnded';

String getAllAdImages = 'Ads/Images';

String modifyStockPrice = 'Stock/UpdatePrice';

String productPriceTaxes = 'Taxes/ProductTaxes';

String productStockRecentlyStocked = 'Products/RecentlyStocked';

String productStockRunningLow  = 'Products/RunningLow';

String allProductRights = 'Rights/Product';

String inventoryPriceTaxes = 'Taxes/InventoryTaxes';

String stockPriceTaxes = 'Taxes/StockTaxes';

String stockPriceDeductions = 'Deductions/StockDeductions';

String orderPend  = 'Orders/Pend';

String orderPayment = 'Orders/Payment';

String orderActivation  = 'Orders/Activate';

String companyProductCollectionsStockOrderAvailable = 'Orders/AvailableProductCollections';

String registerNewOrder = 'Orders/Make';

String orderChartData = 'Orders/ChartEntry';

String companyProductStockItemsOrderAvailable = 'Orders/AvailableStockItems';

String companyTopProductOrderedRequest = 'Orders/TopProductOrdered';

String fetchOrders = 'Orders/AllOrders';

String fetchCustomerOrders = 'Orders/AllCustomerOrders';

String companyOrderSettings = 'Orders/ActiveOrderSettings';

String orderAttendant = 'Orders/Attendant';

String assignAttendant = 'Orders/AssignAttendant';

String fetchAllOrdersInGrouping = 'Orders/AllOrdersInGrouping';

String fetchProductOrders = 'Orders/AllProductOrders';

String groupInDetails = 'Products/AdditionalInfo';

String newProductGroup = 'Products/RegisterProductGroup';

String getProductGroupMetrics = 'Products/ProductGroupMetrics';

String registerNewProductGroupMetrics = 'Products/NewProductGroupMetrics';

String companyProductGroups = 'Products/ProductGroups';

String productInGroups = 'Products/GroupProducts';

String getProductSpecsUnits = 'Products/SpecsMeasurements';

String createProductVariation = 'Products/RegisterVariation';

String getProductVariations = 'Products/Variants';

String productInCollection = 'Products/CollectionProducts';

String addToProductGroup = 'Products/AddToProductGroup';

String removeFromProductGroup = 'Products/RemoveFromProductGroup';

String productAcceptableForGrouping = 'Products/AcceptableProductForGrouping';

String myCompanyProductCollections = 'Products/MyCollections';

String getPaymentProvidersRequest = 'Payments/PaymentMethodProviders';

String registerPaymentMode = 'Payments/RegisterPaymentMethod';

String getCompanyPaymentMethods = 'Payments/PaymentMethods';

String getCompanyPaymentMethodsByStatus  = 'Payments/PaymentMethodByStatus';

String registerCompanyPayment = 'Payments/RegisterPayment';

String registerInventoryStockItemSale = 'Inventory/SellStockItem';

String allAvailablePayments = 'Payments/Payments';

String getProductPayments = 'Products/Payments';

String getIndividualProductPayments = 'Products/IndividualPayments';

String getInventoryPayments = 'Inventory/Payments';

String getIndividualInventoryPayments = 'Inventory/IndividualPayments';

String updateProductStatus = 'Products/UpdateStatus';

String updateInventoryStatus = 'Inventory/UpdateStatus';

String updateProductCollectionStatus = 'Products/UpdateCollectionStatus';

String updateProductGroupStatus = 'Products/UpdateGroupStatus';

String updateProductStockItemStatus = 'Stock/UpdateProductStockItemStatus';

String getEmploymentTypes = 'Employee/EmploymentTypes';

String updateInventoryStockItemStatus = 'Stock/UpdateInventoryStockItemStatus';

String allPaymentsWithExcesses = 'Payments/Excess';

String allCompanyPaymentsWithBalances = 'Payments/Balance';

String allCompanyPaymentsWithRefunds = 'Payments/Refunds';

String allCompanyPaymentsUnderMethod = 'Payments/MadeByMethod';

String fetchPaymentHistory = 'Payments/History';

String financialChartValues = 'Finance/ChartValues';

String saveInventoryItem = 'Inventory/New';

String fetchPaymentExcesses = 'Payments/GetPaymentExcess';

String fetchPaymentBalances  = 'Payments/GetPaymentBalance';

String recalculateDeficits = 'Payments/CalculateDeficit';

String  calculateRepayExcess = 'Payments/RegisterExcessPayment';

String calculateRepayBalance = 'Payments/RegisterBalancePayment';

String balancePaymentHistory = 'Payments/BalancePaymentHistory';

String excessPaymentHistory = 'Payments/ExcessPaymentHistory';

String requestInvalidateBalancePayment = 'Payments/InvalidateBalancePayment';

String requestExcessPaymentHistory = 'Payments/InvalidateExcessPayment';

String updatePaymentMethodState = 'Payments/UpdatePaymentMethodStatus';

String updatePaymentMethodSteps = 'Payments/UpdatePaymentMethodSteps';

String updatePaymentMethodRequest = 'Payments/UpdatePaymentMethodDetails';

String paymentMethodHistory = 'Payments/PaymentMethodHistory';

String refundHistory = 'Payments/RefundPaymentHistory';

String invalidatePaymentEntry = 'Payments/InvalidatePayment';

String getItemsUnderPayment = 'Payments/Items';

String issueRefundRequest = 'Payments/RegisterPaymentRefund';

String requestInvalidateRefundPayment = 'Payments/InvalidateRefundPayment';

String verifyOnboardingCodeCurrentUsage = 'Employee/VerifyCodeUsage';

String onboardToOrganisation = 'Employee/OnBoard';

String declineOnboarding = 'Employee/RejectOnBoard';

String myNotifications = 'Notifications/Mine';

String readNotification = 'Notifications/Read';

String registerAdAsRead = 'Ads/View';

String getMostActiveEmployees = 'ActivityLog/MostActive';

String getRecentlyActiveEmployees = 'ActivityLog/RecentlyActive';

String getEmployeeActivityLogs = 'ActivityLog/Employee';

String getUserInstitutionalActivityLogs = 'ActivityLog/Mine';

String employeeStatsLine = 'Employee/Stats';

String newCompanyNews = 'NewsLetter/RegisterNew';

String highRatedNewsInfo = 'NewsLetter/HighPriority';

String getCompanyOrderSettings = 'Orders/Settings';

String updateBranchOrderSettings = 'Orders/UpdateSettings';

String getOrderPayment = 'Payments/OrderPayment';

String fetchNewsLetterTypes = 'NewsLetter/Types';

String updateNewsLetterViewShipEnd = 'NewsLetter/ViewEnded';

String fetchNewsLetterImages = 'NewsLetter/Images';

String additionalNewsLetterDetails = 'NewsLetter/View';

String getCompanyNewsletters  = 'NewsLetter/All';

String deleteNewsletterAt  = 'NewsLetter/DeleteNow';

String newsletterViewers = 'NewsLetter/Viewers';

String getOrderPointTypes = 'Orders/AllOrderPointType';

String getOrderPointsByType = "Orders/PointsByType";

String getOrderPoint = "Orders/Points";

String newCompanyOrderPoint = 'Orders/RegisterOrderPoint';

String deleteCompanyPoint = 'Orders/DeletePoint';

String generateOrderCustomerQr = 'Orders/CustomerAssignQR';

String viewCustomerOrdered = 'Orders/CustomerDetails';

String unAssignOrderFromCustomer  = 'Orders/UnAssignCustomerOrder';

String confirmOrderCustomerAssignment = 'Orders/VerifyOrderAssignment';

String allActiveBranches = 'Branch/All';

String getAllBranchTypes = 'Branch/Types';

String saveBranch = 'Branch/Register';

String saveOrderPointType = 'Orders/RegisterOrderPointType';

String getActiveOrderPointType = 'Orders/AllOrderPointType';

String employeeToBranchAllocation = 'Employee/EnrollBranch';

String employeeAllocatableBranches = 'Employee/AllocatableBranches';

String createCompanyDepartment = 'Organisation/RegisterDepartment';

String createSubCompanyDepartment = 'Organisation/RegisterSubDepartment';

String createSubSubCompanyDepartment = 'Organisation/RegisterSubSubDepartment';

String getCompanyDepartment = 'Organisation/AllDepartments';

String getCompanySubDepartment = 'Organisation/AllSubDepartments';



