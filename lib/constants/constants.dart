const String DEFAULT_DATE_FORMAT_PATTERN = "yyyy-MM-dd";
const String FRENCH_DATE_FORMAT_PATTERN = "dd/MM/yyyy";

const String FRENCH_DATE_FORMAT_DAY_HOURS_MIN_PATTERN = "dd/MM/yyyy HH:mm";
const String FRENCH_DATE_FORMAT_DAY_HOURS_MIN_SEC_PARSE_PATTERN =
    "yyyy-MM-dd HH:mm:ss";
const String FRENCH_DATE_FORMAT_PATTERN_WITH_HOUR_MIN_SEC =
    "dd/MM/yyyy HH:mm:ss";
const String QC_FILTER_DATE_FORMAT_PATTERN = "yyyy-MM-dd";
const Duration POPUP_TRANSITION_DURATION = Duration(milliseconds: 200);
const Duration DISABLED_LOGIN_DURATION = const Duration(minutes: 2);

const String FRENCH_MONTH_YEAR_FORMAT_PATTERN = "MMMM yyyy";

///////////////
/// Customer Data completion
/// ////////
const String EMAIL_REGEX =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
const String PASSWORD_REGEX =
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[~!@#$%^&*()_+={}[]|:;,.?/]).{6,}$';

const String URL_REGEX =
    r'^(http(s):\/\/.)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$';
// TODO check
const String PHONE_NUMBER_REGEX = r'^[0-9]{9,9}$';
const int FRENCH_PHONE_NUMBER_LENGTH = 9;
const int WRONG_LOGIN_ATTEMPTS_MAX = 5;

const String CAR_PRODUCT_MARQUE_CLASSIFICATION_RESOURCE_ID_MATCHER =
    "asset.good.vehicle.brand.";
const String CURRENCY_SYMBOL = "MAD";
const String DEFAULT_CURRENCY_VALUE = "MAD";
const int DOCUMENT_MAX_HEIGHT = 900;
const int DOCUMENT_MAX_WIDTH = 900;

int ORDERS_PAGE_MAX_LENGTH = 30;
